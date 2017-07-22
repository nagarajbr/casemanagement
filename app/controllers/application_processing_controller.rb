class ApplicationProcessingController < AttopAncestorController
	before_action :set_household_obj
	before_action :set_client_obj, except: :new_application_member_race
	# before_action :set_action_plan_id, except: [:client_activities, :show_client_activity]

	def ready_for_application_processing
		# fail
		# Call method to push Applications queue to ready for application processing queue
		ls_msg = move_application_to_ready_for_application_processing_queue(params[:application_id].to_i)
		if ls_msg == "SUCCESS"
			# redirect to processing first step
			redirect_to application_summary_path(params[:application_id].to_i)
		else
			flash[:alert] = ls_msg
			# redirect_to applications index page
			redirect_to client_applications_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","ready_for_application_processing",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing application."
		redirect_to_back
	end

	def register_add_client_from_client_application
		session[:APPLICATION_ID] = params[:application_id].to_i
		session[:ADD_CLIENT_FROM_CLIENT_APPLICATION] = "Y"
		redirect_to new_household_member_search_path(params[:household_id].to_i)
	end

	def ready_for_processing
		session[:APPLICATION_ID] = params[:application_id].to_i if params[:application_id].present?
		redirect_to start_application_processing_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","ready_for_processing",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing application."
		redirect_to_back
	end

	def application_processing_wizard_initialize
		session[:APPLICATION_PROCESSING_STEP] = nil
		session[:APPLICATION_ID] = nil
		redirect_to start_application_processing_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","application_processing_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to start wizard."
		redirect_to_back
	end

	def start_application_processing_wizard
		@household = Household.find(session[:HOUSEHOLD_ID].to_i)
		if session[:APPLICATION_ID].present?
			@selected_application = ClientApplication.find(session[:APPLICATION_ID].to_i)
			@selected_application.application_processing_current_step = session[:APPLICATION_PROCESSING_STEP]
			populate_instance_variables_for_application_processing_wizard
		else
			if ClientApplication.can_new_application_be_created_for_household?(session[:HOUSEHOLD_ID])
	 			@selected_application = ClientApplication.new
	 			# session[:APPLICATION_ID] = 0
	 			@selected_application.household_id = session[:HOUSEHOLD_ID]
	 			@selected_application.application_status = 5943
	 			@selected_application.application_processing_current_step = session[:APPLICATION_PROCESSING_STEP]
				populate_instance_variables_for_application_processing_wizard
	 		else
	 			redirect_to client_applications_path,alert: "This household is associated with pending application, New application will not be created without disposing the pending application."
	 		end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","start_application_processing_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end

	def process_application_processing_wizard
		# fail
		if session[:APPLICATION_ID].present?
			@selected_application = ClientApplication.find(session[:APPLICATION_ID].to_i)
		else
			if ClientApplication.can_new_application_be_created_for_household?(session[:HOUSEHOLD_ID])
				@selected_application = ClientApplication.new
	 			@selected_application.household_id = session[:HOUSEHOLD_ID]
	 			@selected_application.application_status = 5943
	 		else
	 			redirect_to client_applications_path,alert: "This household is associated with pending application, New application will not be created without disposing the pending application."
	 			# force it to return not to continue with next line of code
	 			return
	 		end
		end
		# coming from hidden variable : params[:client_application][:application_processing_current_step] - for form_for partial
		# coming from hidden variable : params[:application_processing_current_step] - for form_tag partial
		if params[:client_application].present?
			@selected_application.application_processing_current_step = params[:client_application][:application_processing_current_step]
		else
			@selected_application.application_processing_current_step = params[:application_processing_current_step]
		end
		# Step management start
		if params[:back_button].present?
      		 @selected_application.application_processing_previous_step
      	elsif @selected_application.application_processing_last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @selected_application.application_processing_next_step
        end
        session[:APPLICATION_PROCESSING_STEP] = @selected_application.application_processing_current_step
        # Step management end
        #  what to do on each step's Next
		if @selected_application.get_application_processing_object == "application_processing_first" && params[:next_button].present?
        	 @selected_application.assign_attributes(client_application_params)
        	if @selected_application.valid?
        	# if params[:client_application][:application_date].present? && params[:client_application][:application_received_office].present?
        		# @selected_application.assign_attributes(client_application_params)
        		member_object = nil
        		lb_new_application = @selected_application.new_record?
        		# if new_application
        		# 	member_object = ApplicationMember.new
        		# 	member_object.client_id = @client.id
        		# 	member_object.member_status = 4468
        		# end
        		begin
					ActiveRecord::Base.transaction do
						# Save Application
		        		if @selected_application.save!
		        			session[:APPLICATION_ID] = @selected_application.id
		        			# if member_object.present?
		        			# 	member_object.client_application_id = @selected_application.id
		        			# 	member_object.save!
		        			# end
		        			if lb_new_application
		        				 # create queue & task
		    					# step1 : Populate common event management argument structure
								common_action_argument_object = CommonEventManagementArgumentsStruct.new
					            common_action_argument_object.event_id = 865
				                # common_action_argument_object.client_id = session[:CLIENT_ID]
				                common_action_argument_object.queue_reference_type = 6587 # client application
				                common_action_argument_object.queue_reference_id = @selected_application.id
				                common_action_argument_object.client_application_id = @selected_application.id
				                common_action_argument_object.queue_worker_id = current_user.uid
				                # step2: call common method to process event.
					            ls_msg = EventManagementService.process_event(common_action_argument_object)
		        			end
					 	end
					 	move_application_to_ready_for_application_processing_queue(session[:APPLICATION_ID])
					 	redirect_to start_application_processing_wizard_path
				 	end
				rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","process_application_processing_wizard step1 save",err,AuditModule.get_current_user.uid)
					flash[:alert] = "Failed to create new application - for more details refer to Error ID: #{error_object.id}."
					session[:APPLICATION_PROCESSING_STEP] = @selected_application.application_processing_previous_step
					redirect_to start_application_processing_wizard_path
				end
        	else
        		# @selected_application.errors[:application_date] = "is required" if params[:client_application][:application_date].blank?
        		# @selected_application.errors[:application_received_office] = "is required" if params[:client_application][:application_received_office].blank?
        		go_to_previous_step
        		render :start_application_processing_wizard
        	end
         elsif @selected_application.get_application_processing_object == "application_processing_second" && params[:next_button].present?
         	application_members = ApplicationMember.sorted_application_members(@selected_application.id)
         	if application_members.size > 0
         		ls_message = move_application_to_ready_for_application_processing_queue(@selected_application.id)
	         	if ls_message == "SUCCESS"
	         	 	redirect_to start_application_processing_wizard_path
	         	else
	         	 	go_to_previous_step
					flash[:notice] = ls_message
	        		render :start_application_processing_wizard
	         	end
         	else
         		go_to_previous_step
				@selected_application.errors[:base] << "Atleast one member should be included in the application."
        		render :start_application_processing_wizard
         	 end
    	# elsif @selected_application.get_application_processing_object == "application_processing_third" && params[:next_button].present?
    	# 	self_client_id = params[:client_application][:self_client_id].to_i
    	# 	if self_client_id.present?
    	# 		if ApplicationMember.update_primary_applicant_application(@selected_application.id,self_client_id) == "SUCCESS"
    	# 			@selected_application.self_client_id = self_client_id
    	# 			session[:CLIENT_ID] = self_client_id
    	# 		else
    	# 			flash[:alert] = "Failed to Save the Primary Applicant"
    	# 		end
    	# 	else
    	# 		go_to_previous_step
    	# 		@selected_application.errors[:base] << "Primary applicant is required"
    	# 		render :start_application_processing_wizard
    	# 	end


		elsif @selected_application.get_application_processing_object == "application_processing_sixth" && params[:next_button].present?
			# Race is not mandatory, this check will be done at ED
			#f all_application_members_has_race_information
				redirect_to start_application_processing_wizard_path
			#lse
			#go_to_previous_step
			#flash[:alert] = "Please enter race information for all the application members"
        	#render :start_application_processing_wizard
			#end
		elsif @selected_application.get_application_processing_object == "application_processing_fourth" && params[:next_button].present?
			redirect_to start_application_processing_wizard_path
			# fail
		elsif @selected_application.application_processing_last_step?
			self_client_id = params[:client_application][:self_client_id]
			if params[:client_application][:application_disposition_status].present? && params[:client_application][:application_disposition_reason].present? && self_client_id.present?
				self_client_id = self_client_id.to_i
        		@selected_application.assign_attributes(client_application_params)
        		@selected_application.disposition_date  = Time.now.to_date
        		@selected_application.application_status  = 5942 # "Complete"
    			# primary_contact = nil
    			# primary_contacts = PrimaryContact.get_primary_contact_for_application(@selected_application.id)

    			# if primary_contacts.present?
    			# 	primary_contact = primary_contacts.first
    			# else
    			# 	primary_contact = PrimaryContact.new
    			# 	primary_contact.reference_id = @selected_application.id
    			# end

    			# primary_contact.reference_type = 6587 # Client Application
    			# primary_contact.client_id = self_client_id

    			begin
					ActiveRecord::Base.transaction do
						if @selected_application.save!
		        			notice_string = nil
		        			url = alerts_path
		        			if @selected_application.application_disposition_status == 6017 # "Accepted"
		        				# primary_contact.save!
		        				PrimaryContactService.save_primary_contact(@selected_application.id, 6587, self_client_id)
		        				session[:PROGRAM_UNIT_PROCESSING_LOCATION] = params[:client_application][:program_unit_processing_location].to_i
		        				common_action_argument_object = CommonEventManagementArgumentsStruct.new
							 	common_action_argument_object.event_id = 866
							 	common_action_argument_object.queue_reference_type = 6587 # client application
							 	common_action_argument_object.queue_reference_id = @selected_application.id
							 	common_action_argument_object.client_application_id = @selected_application.id
							 	ls_msg = EventManagementService.process_event(common_action_argument_object)
							 	notice_string = "Application Accepted"
		        			elsif @selected_application.application_disposition_status == 6018 # the status is rejected
		        				session[:APPLICATION_PROCESSING_STEP] = nil
		        				session[:APPLICATION_ID] = nil
		        				# url = alerts_path
		        				# step1 : Populate common event management argument structure
								common_action_argument_object = CommonEventManagementArgumentsStruct.new
					            common_action_argument_object.event_id = 243
				                common_action_argument_object.client_id = session[:CLIENT_ID]
				                common_action_argument_object.selected_app_action = params[:client_application][:application_disposition_status].to_i
				                common_action_argument_object.app_action_reason = params[:client_application][:application_disposition_reason].to_i
				                common_action_argument_object.queue_reference_type = 6587 # client application
				                common_action_argument_object.queue_reference_id = @selected_application.id
				                common_action_argument_object.client_application_id = @selected_application.id
					            # step2: call common method to process event.
					            ls_msg = EventManagementService.process_event(common_action_argument_object)
					            notice_string = "Application Rejected"
		        			end
		        			redirect_to url, notice: notice_string
		        		end
	        		end

				rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","process_application_processing_wizard",err,AuditModule.get_current_user.uid)
					flash[:alert] = "Failed to accept or reject an application - for more details refer to Error ID: #{error_object.id}."
					redirect_to start_application_processing_wizard_path
				end
        	else
        		@selected_application.errors[:self_client_id] << "is required." if self_client_id.blank?
        		@selected_application.errors[:application_disposition_status] = "is required." if params[:client_application][:application_disposition_status].blank?
        		@selected_application.errors[:application_disposition_reason] = "is required." if params[:client_application][:application_disposition_reason].blank?
        		# go_to_previous_step
        		common_instances_for_application_processing_wizard
        		instances_for_application_processing_fifth_step
        		render :start_application_processing_wizard
        	end
		# elsif @selected_application.application_processing_last_step?
			# fail
		# 	if params[:service_programs].present?
		# 		screening_input = {}
  #   			screening_input[:service_programs] = params[:service_programs]
  #   			screening_input[:program_unit_processing_location] = session[:PROGRAM_UNIT_PROCESSING_LOCATION]
		# 		program_units = CaseCreatorService.determine_cases(session[:APPLICATION_ID], screening_input)
		# 		begin
		# 			ActiveRecord::Base.transaction do
		# 				@selected_application.application_status = 5942
		# 				@selected_application.save!
		# 				if program_units.present?
		# 					program_units.each do |program_unit|
		# 						common_action_argument_object = CommonEventManagementArgumentsStruct.new
		# 					 	common_action_argument_object.event_id = 866
		# 					 	common_action_argument_object.queue_reference_type = 6345 # program unit
		# 					 	common_action_argument_object.queue_reference_id = program_unit.id
		# 					 	common_action_argument_object.client_application_id = program_unit.client_application_id
		# 					 	ls_msg = EventManagementService.process_event(common_action_argument_object)
		# 					 	if ls_msg != "SUCCESS"
		# 					 		break
		# 				     	end
		# 					end
		# 				end
		# 			end
		# 		rescue => err
		# 			error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","application_processing_seventh",err,AuditModule.get_current_user.uid)
		# 			ls_msg = "Failed to move selected programs units into ED queue - for more details refer to Error ID: #{error_object.id}."
		# 		end
		# 		session[:APPLICATION_ID] = nil
		# 		redirect_to alerts_path, notice: "Program Units are ready for eligibility determination"
		# 	else
		# 		session[:APPLICATION_PROCESSING_STEP] = @selected_application.application_processing_current_step
		# 		instances_for_application_processing_seventh_step
		# 		flash.now[:notice] = "No Program Units availble for this client to run eligibility"
  #       		render :start_application_processing_wizard
		# 	end
		else
			# fail
			redirect_to start_application_processing_wizard_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","process_application_processing_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when completing application."
		redirect_to application_processing_wizard_initialize_path
		# redirect_to_back
	end

	def edit_application_members
		objects_for_edit_application_members
		if @household_members.blank?
			redirect_to start_application_processing_wizard_path, notice: "All household members are within the application. No more members to add."
		else
			@application_member = @selected_application.application_members.new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","edit_application_members",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while trying to add application member to the application."
		redirect_to_back
	end

	def add_application_member
		@selected_application = ClientApplication.find(session[:APPLICATION_ID])
		@application_member = @selected_application.application_members.new
		if params[:application_member][:client_id].present?
			@application_member.client_id = params[:application_member][:client_id].to_i
			@application_member.member_status = 4468 # "Active"
			@application_member.save
			if params[:save_and_add].present?
				objects_for_edit_application_members
				render :edit_application_members
			else
				redirect_to start_application_processing_wizard_path
			end
		else
			objects_for_edit_application_members
			@application_member.errors[:base] << "Please select application member to be added."
			render :edit_application_members
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","add_application_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while adding application member to the application."
		redirect_to_back
	end

	def index_application_member_race
		@selected_application = ClientApplication.find(session[:APPLICATION_ID])
		@selected_application.application_processing_current_step = session[:APPLICATION_PROCESSING_STEP]
		@step_number = @selected_application.get_application_processing_wizard_step_number
		@application_members_with_race = ApplicationMember.get_application_members_who_has_race_information(session[:APPLICATION_ID])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","index_application_member_race",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while rendering index application member race."
		redirect_to_back
	end

	def new_application_member_race
		instances_for_new_application_member_race
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","new_application_member_race",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while rendering application member race."
		redirect_to_back
	end

	def create_application_member_race
		if race_params[:id].present? && race_params[:ethnicity].present? && race_params[:race_ids].count > 1
			@client = Client.find(params[:client][:id].to_i)
			if @client.present?
				# @client.ethnicity = race_params[:ethnicity]
				# @client.race_ids = race_params[:race_ids]
				@client.assign_attributes(race_params)
				ls_msg = ClientRaceService.create_and_update_client_race_and_notes(@client,params[:notes])
				if ls_msg == "SUCCESS"
					if params[:save_and_add].present?
						redirect_to new_application_member_race_path, notice: "Race information saved."
					else
						redirect_to start_application_processing_wizard_path, notice: "Race information saved."
					end
				else
					instances_for_new_application_member_race
					flash[:notice] = "Can't create race."
					render :new_application_member_race
				end
			end
		else
			instances_for_new_application_member_race
			if race_params[:id].present?
				@client = Client.find(race_params[:id].to_i)
			else
				@client.errors[:base] << "Please select an application member."
			end
			@client.race_ids = race_params[:race_ids]
			@client.ethnicity = race_params[:ethnicity]
			@notes = params[:notes]
			if race_params[:ethnicity].blank?
				@client.errors[:base] << "Ethnicity is required."
			end
			if race_params[:race_ids].count < 2
				@client.errors[:base] << "Race is required."
			end
			render :new_application_member_race
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","create_application_member_race",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while saving race information for application member."
		redirect_to_back
	end

	# def back_to_application_processing_wizard
	# 	@selected_application = ClientApplication.find(session[:APPLICATION_ID].to_i)
	# 	@selected_application.application_processing_current_step = session[:APPLICATION_PROCESSING_STEP]
	# 	session[:APPLICATION_PROCESSING_STEP] = @selected_application.application_processing_previous_step
	# 	case session[:APPLICATION_PROCESSING_STEP]
	# 	when "application_processing_fifth"
	# 		redirect_to start_application_processing_wizard_path
	# 	when "application_processing_sixth"
	# 		redirect_to index_application_member_race_path
	# 	when "application_processing_seventh"
	# 		redirect_to determine_possible_cases_path
	# 	end
	# end

	def application_summary
		session[:APPLICATION_ID] = params[:application_id].to_i
		session[:APPLICATION_PROCESSING_STEP] = nil
		program_unit_object = ProgramUnit.latest_program_unit_for_application(session[:APPLICATION_ID].to_i)
		if program_unit_object.present?
			session[:PROGRAM_UNIT_ID] = program_unit_object.id
		else
			session[:PROGRAM_UNIT_ID] = nil
		end

		if session[:PRIMARY_APPLICANT].present?
			session[:CLIENT_ID] = session[:PRIMARY_APPLICANT]
			session[:PRIMARY_APPLICANT] = nil
		end

		# Manoj 02/24/2016 - start
		# My Applications select link will navigate to this - that time No client ID is selected - hence setting clint ID in the session.
		# if session[:CLIENT_ID].blank?
			primary_contact = PrimaryContact.get_primary_contact_for_application(session[:APPLICATION_ID].to_i)
			if primary_contact.present?
				session[:CLIENT_ID] = primary_contact.client_id
			else
				application_adults_collection =ApplicationMember.get_adults_in_the_application(session[:APPLICATION_ID].to_i)
				if application_adults_collection.present?
					application_adult_object = application_adults_collection.first
					session[:CLIENT_ID] =application_adult_object.client_id
				else
					application_member_collection =ApplicationMember.sorted_application_members(session[:APPLICATION_ID].to_i)
					#Rails.logger.debug("application_member_collection = #{application_member_collection.inspect}")
					application_member_object = application_member_collection.first
					session[:CLIENT_ID] =application_member_object.client_id
				end
			end
		# end
		# Manoj 02/24/2016 - end



		@client = Client.find(session[:CLIENT_ID])
		set_household_member_info_in_session(session[:CLIENT_ID])
		@household = Household.find(session[:HOUSEHOLD_ID])
		# @client_applications = ClientApplication.get_completed_applications_list(@client.id)
		@selected_application = ClientApplication.find(params[:application_id].to_i)
		# @client_applications = @selected_application
		app_srvc_prgm_collection = ApplicationServiceProgram.get_application_service_program_object(@selected_application.id)
		if app_srvc_prgm_collection.present?
			@selected_application.selected_service_program = app_srvc_prgm_collection.first.service_program_id
		end

		@application_members = ApplicationMember.sorted_application_members_and_member_info(@selected_application.id)
		@client_relationships = ClientRelationship.get_apllication_member_relationships( @selected_application.id)
		app_data_val_serv_obj = ApplicationDataValidationService.new
		app_data_val_serv_obj.validate(@selected_application.id)
		@data_validation_results = DataValidation.get_data_validation_results(@selected_application.id)
		@client_doc_verification_list = ClientDocVerfication.get_verified_documents(@selected_application.id)
		fts = FamilyTypeService.new
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct = fts.determine_family_type(@selected_application.id)
		@family_type_struct.application_date = @selected_application.application_date
		@family_type_struct.household_id = session[:HOUSEHOLD_ID]
		@case_type = @family_type_struct.case_type
		if DataValidation.are_all_the_date_validations_complete(@selected_application.id, "APP")
			appl_eligibilty_servc = ApplicationEligibilityService.new
			appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
			@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationProcessingController","application_summary",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end

	def household_relations
		session[:NAVIGATE_FROM] = start_application_processing_wizard_path
		redirect_to navigate_to_household_relations_path
	end

	private

		# Manoj 01/22/2016
		# def move_application_to_applications_queue(arg_application_id)
		# 	common_action_argument_object = CommonEventManagementArgumentsStruct.new
		# 	common_action_argument_object.event_id = 865 # Save Button -- event type for client application
  #           common_action_argument_object.queue_reference_type = 6587 # client application
  #           common_action_argument_object.queue_reference_id =  arg_application_id
  #           common_action_argument_object.queue_worker_id = current_user.uid
  #           # for task
  #           common_action_argument_object.client_application_id =  arg_application_id

  #           # step2: call common method to process event.
  #           ls_msg = EventManagementService.process_event(common_action_argument_object)
  #           return ls_msg
		# end

		def move_application_to_ready_for_application_processing_queue(arg_application_id)
			# Move to Ready for Application processing queue
			# complete applications task
			# create work on Application processing task
			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
			common_action_argument_object.event_id = 309 # Save Button
            common_action_argument_object.queue_reference_type = 6587 # client application
            common_action_argument_object.queue_reference_id = arg_application_id
            common_action_argument_object.queue_worker_id = current_user.uid
            # for task
            common_action_argument_object.client_application_id = arg_application_id

            # step2: call common method to process event.
            ls_msg = EventManagementService.process_event(common_action_argument_object)
            return ls_msg
		end



		def set_client_obj
			if session[:CLIENT_ID].present?
				@client = Client.find(session[:CLIENT_ID])
			end
		end

		def set_household_obj
			if session[:HOUSEHOLD_ID].present?
				@household = Household.find(session[:HOUSEHOLD_ID])
			end
	  	end

		def client_application_params
		  	params.require(:client_application).permit(:application_date, :application_status, :application_disposition_status,
												       :application_disposition_reason, :application_origin, :service_program_group,
												       :disposition_date, :application_received_office, :intake_worker_id, :household_id)
    	end

    	def race_params
		  	params.require(:client).permit(:id,:ethnicity, race_ids: [])
		end

		def populate_instance_variables_for_application_processing_wizard
    		common_instances_for_application_processing_wizard
    		case @selected_application.application_processing_current_step
			when "application_processing_first"
				@partial = "client_applications/client_application_first_step"
				@div_class = 5
			when "application_processing_second"
				@partial = "application_processing_second_step"
				@application_members =ApplicationMember.sorted_application_members_and_member_info(@selected_application.id)
				# @application_members =ApplicationMember.sorted_application_members(@selected_application.id)
				# @div_class = "large-12 columns"
				# @div_class = 12
			when "application_processing_third"
				instances_for_application_processing_third_step
			when "application_processing_fourth"
				@partial = "application_screenings/application_screening_fourth_step" # Fix Data
				# @div_class = "large-12 columns"
				# @div_class = 12
				#  Application Eligibility Run & Results.
      			fts = FamilyTypeService.new
				@family_type_struct = FamilyTypeStruct.new
				@family_type_struct = fts.determine_family_type(@selected_application.id)
				@family_type_struct.application_date = @selected_application.application_date
				@family_type_struct.household_id = session[:HOUSEHOLD_ID]
				@case_type = @family_type_struct.case_type
				appl_eligibilty_servc = ApplicationEligibilityService.new
				@family_type_struct.validate_race_information = false
				appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
				@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
				@called_from = "APP_PROCESSING_WIZARD"
				session[:NAVIGATE_FROM] = nil
			when "application_processing_fifth" # Accept/Reject
				instances_for_application_processing_fifth_step

			when "application_processing_sixth" # Race Step
				@show_race = true
				@application_members =ApplicationMember.sorted_application_members_and_member_info(@selected_application.id)
				# @application_members = ApplicationMember.sorted_application_members(session[:APPLICATION_ID])
				@application_members_with_race = ApplicationMember.get_application_members_who_has_race_information(session[:APPLICATION_ID])
				@partial = "application_processing_sixth_step"
			when "application_processing_seventh"
				instances_for_application_processing_seventh_step
			end
    	end

    	def instances_for_new_application_member_race
    		@client = Client.new
			@selected_application = ClientApplication.find(session[:APPLICATION_ID])
			@show_race = true
			@application_members = ApplicationMember.sorted_application_members_and_member_info(session[:APPLICATION_ID])
			@application_members_with_race = ApplicationMember.get_application_members_who_has_race_information(session[:APPLICATION_ID])
			@application_members_without_race = @application_members - @application_members_with_race
			@client_races_in_db_array = []
		end

    	def instances_for_application_processing_third_step
    		# @div_class = 5
			@partial = "client_applications/client_application_third_step"
			# @application_members = ApplicationMember.sorted_application_members(@selected_application.id)

			# To determine primary application contact use
			# 1. List all adults in the application
			# 2. If none found, list all adults in household
			# 3. If none found, list parents found in the household (based on parent child relationship)
			# 4. if none found, list anyone over the age of 15
			@application_members = ApplicationMember.get_adults_in_the_application(@selected_application.id)
			@application_members = HouseholdMember.get_all_adults_with_in_household(session[:HOUSEHOLD_ID]) if @application_members.blank?
			@application_members = HouseholdMember.get_all_parents_with_in_household(session[:HOUSEHOLD_ID]) if @application_members.blank?
			@application_members = HouseholdMember.get_anyone_in_household_over_age_fifteen(session[:HOUSEHOLD_ID]) if @application_members.blank?
	      	# primary_applicant_object = ApplicationMember.get_primary_applicant(@selected_application.id)
	      	primary_applicant_object = PrimaryContact.get_primary_contact_for_application(@selected_application.id)
	      	@selected_application.self_client_id = primary_applicant_object.client_id if primary_applicant_object.present?
	      	# if primary_applicant_object.present?

	      		# Rails.logger.debug("primary_applicant_object = #{primary_applicant_object.inspect}")
	      		# @selected_application.self_client_id = primary_applicant_object.first.client_id
	      		# @selected_application.self_client_id = primary_applicant_object.client_id

	      		# @selected_application.self_client_id = primary_applicant_object.client_id

	      	# end
    	end

    	def instances_for_application_processing_fifth_step
    		instances_for_application_processing_third_step
    		@partial = "application_processing_fifth_step"
    		@application_disposition_types = CodetableItem.item_list(127," Application Disposition status")
  			@mappings = CodetableItem.item_list(66,"Application Disposition List")
			@application_disposition_reasons = @mappings.inject({}) do |options, mapping|
				if mapping.id == 6045
					(options[6017] ||= []) << [CodetableItem.get_short_description(mapping.id), mapping.id]
				else
					(options[6018] ||= []) << [CodetableItem.get_short_description(mapping.id), mapping.id]
				end
			  options
			end
			if session[:PROGRAM_UNIT_PROCESSING_LOCATION].present?
				@selected_application.program_unit_processing_location = session[:PROGRAM_UNIT_PROCESSING_LOCATION]
			end
    	end

    	def objects_for_edit_application_members
			@selected_application = ClientApplication.find(params[:application_id].to_i)
			@household_members = HouseholdMember.get_all_members_in_the_household(session[:HOUSEHOLD_ID])
			@application_members = ApplicationMember.sorted_application_members_and_member_info(@selected_application.id)
			@household_members = @household_members.where("household_members.client_id not in (select application_members.client_id
				                                                                               from application_members
				                                                                               where application_members.client_application_id = ?)",params[:application_id].to_i)
		end

		def common_instances_for_application_processing_wizard
			@div_class = 12
			@step_number = @selected_application.get_application_processing_wizard_step_number
			@form_type = "form_for"
			@form_path = process_application_processing_wizard_path
			@model_object = @selected_application
		end

		def go_to_previous_step
			@selected_application.application_processing_previous_step
    		session[:APPLICATION_PROCESSING_STEP] = @selected_application.application_processing_current_step
    		populate_instance_variables_for_application_processing_wizard
		end

		# def all_application_members_has_race_information
		# 	application_members = ApplicationMember.sorted_application_members(session[:APPLICATION_ID])
		# 	application_members_with_race = ApplicationMember.get_application_members_who_has_race_information(session[:APPLICATION_ID])
		# 	application_members.count == application_members_with_race.count
		# end

		def instances_for_application_processing_seventh_step
			session[:NAVIGATE_FROM] = nil
			@form_type = "form_tag"
			if session[:APPLICATION_ID].present?
				@service_program_id = 1
				screening_only = true
				@family_comp = CaseCreatorService.determine_cases(session[:APPLICATION_ID], screening_only)
				@selected_application = ClientApplication.find(session[:APPLICATION_ID].to_i)
				@selected_application.application_processing_current_step = session[:APPLICATION_PROCESSING_STEP]
				@program_units = []
				@service_programs = ServiceProgram.get_service_programs_for_category_id(6015)
				if @family_comp.present? && @family_comp.class.name != "String"
					@family_comp.family_structure.each do |family_struct|
						@program_units << family_struct.program_unit_id
					end
				end
			end
		end
end
