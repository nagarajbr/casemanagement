class ApplicationScreeningsController < AttopAncestorController
#  Author : Manoj Patil
#  Date: 09/18/2014
#  Description : Application Screening Wizard functionality coded here.


	def view_screening_summary
		#1. Application
		# 2. Application Data Verification Results
		# 3. Application Document Verification Results
		# 4. Application Screening Results
		# 5. Application Disposition Results.

		if session[:PRIMARY_APPLICANT].present?
			session[:CLIENT_ID] = session[:PRIMARY_APPLICANT]
			session[:PRIMARY_APPLICANT] = nil
		end

		@client = Client.find(session[:CLIENT_ID])
		@client_applications = ClientApplication.get_completed_applications_list(@client.id)
		@selected_application = ClientApplication.find(params[:application_id])
		app_srvc_prgm_collection = ApplicationServiceProgram.get_application_service_program_object(@selected_application.id)
		if app_srvc_prgm_collection.present?
			@selected_application.selected_service_program = app_srvc_prgm_collection.first.service_program_id
		end

		@application_members = ApplicationMember.sorted_application_members_and_member_info(@selected_application.id)
		@client_relationships = ClientRelationship.get_apllication_member_relationships( @selected_application.id)
		# validate
		app_data_val_serv_obj = ApplicationDataValidationService.new
		app_data_val_serv_obj.validate(@selected_application.id)
		@data_validation_results = DataValidation.get_data_validation_results(@selected_application.id)
		@client_doc_verification_list = ClientDocVerfication.get_verified_documents(@selected_application.id)
		fts = FamilyTypeService.new
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct = fts.determine_family_type(@selected_application.id)
		@family_type_struct.application_date = @selected_application.application_date
		@case_type = @family_type_struct.case_type
		if DataValidation.are_all_the_date_validations_complete(@selected_application.id, "APP")
			appl_eligibilty_servc = ApplicationEligibilityService.new
			appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
			@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
		end

		# logger.debug "@family_type_struct -inspect = #{@family_type_struct.inspect}"

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","view_screening_summary",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end

	def application_check_program_eligibility_wizard_initialize
		# Initilaize wizard
		# Called from Application screening link.
		session[:APPLICATION_SCREENING_STEP] = session[:NEW_APPLICATION_SCREENING_ID] = session[:PRIMARY_APPLICANT] =  nil
		application_screening_object = ApplicationScreening.manage_application_screening(params[:application_id].to_i)
		session[:NEW_APPLICATION_SCREENING_ID] = application_screening_object.id
		primary_applicant_collection = ApplicationMember.get_primary_applicant(params[:application_id].to_i)
		if primary_applicant_collection.present?
			session[:PRIMARY_APPLICANT] = primary_applicant_collection.first.client_id
		end
		redirect_to start_check_program_eligibility_wizard_path(params[:application_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","application_check_program_eligibility_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end


	def start_check_program_eligibility_wizard

		# Multi step form - wizard
		@client = Client.find(session[:CLIENT_ID])
		# similar to EDIT REST action.
		@selected_application = ClientApplication.find(params[:application_id])
		# logger.debug "session[:NEW_APPLICATION_SCREENING_ID] -inspect= #{session[:NEW_APPLICATION_SCREENING_ID].inspect}"
		@application_screening = ApplicationScreening.find(session[:NEW_APPLICATION_SCREENING_ID].to_i)
		 #  which step object to be shown on the start_check_program_eligibility_wizard.html.erb
      	@application_screening.current_step = session[:APPLICATION_SCREENING_STEP]

		if session[:PRIMARY_APPLICANT].present?
			session[:CLIENT_ID] = session[:PRIMARY_APPLICANT]
			session[:PRIMARY_APPLICANT] = nil
		end


      		if session[:APPLICATION_SCREENING_STEP] == "application_screening_first" || @application_screening.current_step == "application_screening_first"
      			# step 1
      			@application_members = ApplicationMember.sorted_application_members_and_member_info(@selected_application.id)
      			@client_relationships = ClientRelationship.get_apllication_member_relationships( @selected_application.id)
      		elsif session[:APPLICATION_SCREENING_STEP] == "application_screening_second"
      			#  step 2
	      		# Call Data Validation Service Object.
	      		application_srvc_object = ApplicationDataValidationService.new
				 application_srvc_object.validate(@selected_application.id)
				 # get records from Datavalidation table for selected application ID
				 @data_validation_results = DataValidation.get_data_validation_results_to_be_corrected(@selected_application.id)
      		elsif session[:APPLICATION_SCREENING_STEP] == "application_screening_third"

      			@client_doc_verification_list = ClientDocVerfication.get_verified_documents(@selected_application.id)
      		elsif session[:APPLICATION_SCREENING_STEP] == "application_screening_fourth"

      			#  Application Eligibility Run & Results.
      			fts = FamilyTypeService.new
				@family_type_struct = FamilyTypeStruct.new
				@family_type_struct = fts.determine_family_type(@selected_application.id)
				@family_type_struct.application_date = @selected_application.application_date
				@case_type = @family_type_struct.case_type
				appl_eligibilty_servc = ApplicationEligibilityService.new
				appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
				@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
				if @family_type_struct.case_type_integer == 6046 || @family_type_struct.case_type_integer == 6047 || @family_type_struct.case_type_integer == 6048 || @family_type_struct.case_type_integer == 6049
					@application_screening.determined_case_type = @family_type_struct.case_type_integer
					@application_screening.save
				end
				@called_from = "APP_SCREENING_WIZARD"
               # Set up Serverice program selection -start

      		elsif session[:APPLICATION_SCREENING_STEP] == "application_screening_last"



      			last_step_objects()
      		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","start_check_program_eligibility_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end

	def process_check_program_eligibility_wizard



		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.
		# Rule 3 - After Processing is done send it back to start_check_program_eligibility_wizard - because that is where
		#          views corresponding to each step is opened.

		# similar to UPDATE REST action.
		@client = Client.find(session[:CLIENT_ID])

		# Instantiate Application Data validation Service Object
		application_srvc_object = ApplicationDataValidationService.new

		# similar to EDIT REST action.
		@selected_application = ClientApplication.find(params[:application_id])

		application_srvc_object = ApplicationDataValidationService.new


  		@application_screening = ApplicationScreening.find(session[:NEW_APPLICATION_SCREENING_ID].to_i)

      	#  first step is assigned to current step -when session[:APPLICATION_SCREENING_STEP] is null
      	@application_screening.current_step = session[:APPLICATION_SCREENING_STEP]

      	@application_screening_error = SystemParam.new # place holder error object
      	@application_screening_error.description = ""
      	# Manage steps -start
      	if params[:back_button].present?
      		 @application_screening.previous_step
      	elsif @application_screening.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @application_screening.next_step
        end
       session[:APPLICATION_SCREENING_STEP] = @application_screening.current_step
       # Manage steps -end

        # what step to process?
		if @application_screening.get_process_object == "application_screening_first" && params[:next_button].present?
			# No processing in this step - just take it to next step - where based on session[:APPLICATION_SCREENING_STEP]
			# corresponding data for second step is displayed.
			redirect_to start_check_program_eligibility_wizard_path(params[:application_id])
		elsif @application_screening.get_process_object == "application_screening_second" && params[:next_button].present?
			# check from displayed Data validations - All Records should Say - VALID - Then Only Proceed to Next Step.
			# Call Data Validation Service Object.
				 application_srvc_object.validate(@selected_application.id)
				 # get records from Datavalidation table for selected application ID
				 data_validation_results = DataValidation.get_data_validation_results(@selected_application.id)
				all_valid = true
				if data_validation_results.size > 0
					 data_validation_results.each do |arg_validation|
					 	if arg_validation.result == false
					 		all_valid = false
					 		break
					 	end
					 end
				end
				 @data_validation_results = DataValidation.get_data_validation_results_to_be_corrected(@selected_application.id)
				if all_valid == true
				 	redirect_to start_check_program_eligibility_wizard_path(params[:application_id])
				else

				 	@application_screening.previous_step
			 		session[:APPLICATION_SCREENING_STEP] = @application_screening.current_step
			 		#flash[:alert] = "Correct All Data Verification errors to Proceed to Next Step"
			 		@application_screening_error.errors[:base] << "Enter all required information to proceed to the next step."
			 		render :start_check_program_eligibility_wizard
			 		#redirect_to start_check_program_eligibility_wizard_path(params[:application_id])
				end

		elsif @application_screening.get_process_object == "application_screening_third" && params[:next_button].present?
			redirect_to start_check_program_eligibility_wizard_path(params[:application_id])

		elsif @application_screening.get_process_object == "application_screening_fourth" && params[:next_button].present?

				redirect_to start_check_program_eligibility_wizard_path(params[:application_id])


		elsif @application_screening.current_step == "application_screening_last"

			last_step_objects()

			#  Call Method to save Disposition status and service Program
			l_params = client_select_service_program_params
			save_service_program(@selected_application.id,l_params,params)

		else

			# previous button is clicked.
			redirect_to start_check_program_eligibility_wizard_path(params[:application_id])
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","process_check_program_eligibility_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when screening application."
		redirect_to_back


	end

	def exit_wizard
		# destroy Application screening record
		if session[:NEW_APPLICATION_SCREENING_ID].present?
			application_screening.find(session[:NEW_APPLICATION_SCREENING_ID].to_i)
			application_screening.destroy
		end
		# reset all session variables
		session[:APPLICATION_SCREENING_STEP] = session[:NEW_APPLICATION_SCREENING_ID] =  nil
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","exit_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid application."
		redirect_to_back
	end


	def new_verification_document

		@selected_application = ClientApplication.find(params[:application_id])
		@application_members = ApplicationMember.sorted_application_members(@selected_application.id)
		@client_doc_verification = ClientDocVerfication.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","new_verification_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when screening application."
		redirect_to_back
	end

	def create_verification_document
		@client = Client.find(session[:CLIENT_ID])
		@selected_application = ClientApplication.find(params[:application_id])
		@application_members = ApplicationMember.sorted_application_members(@selected_application.id)
		l_params = client_doc_verification_params
		@client_doc_verification = ClientDocVerfication.new(l_params)
		if @client_doc_verification.save
			flash[:notice] = "Verification document added."
			redirect_to start_check_program_eligibility_wizard_path(@selected_application.id)
		else
			render :new_verification_document
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","create_verification_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when creating verification document."
		redirect_to_back

	end

	def delete_verification_document
		@selected_application = ClientApplication.find(params[:application_id])
		@client_doc_verification = ClientDocVerfication.find(params[:document_id])
		@client_doc_verification.destroy
		flash[:alert] = "Selected Document Deleted"
		redirect_to start_check_program_eligibility_wizard_path(@selected_application.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","delete_verification_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when deleting verification document."
		redirect_to_back
	end


	def application_eligibility_correction_link
		session[:PRIMARY_APPLICANT] = session[:CLIENT_ID]
		application_eligibility_result_object = ApplicationEligibilityResults.find(params[:id])

		client_application_id = application_eligibility_result_object.application_id
		session[:CLIENT_ID] = application_eligibility_result_object.client_id

		case params[:called_from]
		when "APP_SCREENING_WIZARD"
			session[:NAVIGATE_FROM] = start_check_program_eligibility_wizard_path(application_eligibility_result_object.application_id)
		when "APP_SCREENING_VIEW"
        	session[:NAVIGATE_FROM] = view_screening_summary_path(application_eligibility_result_object.application_id)
        when "APP_PROCESSING_WIZARD"
        	session[:NAVIGATE_FROM] = start_application_processing_wizard_path
        when "NAVIGATOR"
        	session[:NAVIGATE_FROM] = navigator_validations_path
        else
        	session[:NAVIGATE_FROM] = show_application_screening_result_path(application_eligibility_result_object.application_id)
		end


		case application_eligibility_result_object.data_item_type.to_i
			when 6036 #"Education"
				redirect_to educations_path("CLIENT")
			when 6037 #"Deprivation"
				redirect_to client_parental_rspabilities_path
			when 6035 #"Immunization"
				redirect_to show_client_immunization_path("CLIENT")
			when 6038 #"WorkParticipation"
				redirect_to index_client_characteristic_path("clients","work")
			when 6087 #"Living Arrangement"
				redirect_to living_arrangement_path("application", client_application_id)
			when 6088 #"State Residence"
				redirect_to show_alien_path(params[:id])
			when 6089 #"Citizenship or Eligible Alien"
				redirect_to show_alien_path(params[:id])
			when 6750 #"Household Registration"
				if params[:called_from] == "APP_PROCESSING_WIZARD"
					session[:CALLED_FROM] = start_application_processing_wizard_path
				else
					session[:CALLED_FROM] = navigator_validations_path
				end
				redirect_to household_member_registration_status_path
			when 6751 #"Date of Birth"
				redirect_to show_client_path
			when 6752 #"Felon characteristic"
				redirect_to index_client_characteristic_path("clients","legal")
			when 6753 #"Outs of state payments"
				redirect_to out_of_state_payments_path
			when 6754 #"Race Information"
				redirect_to show_race_path
			when 6765 #"Physical Address not verified"
				redirect_to show_contact_information_path
		end


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningsController","application_eligibility_correction_link",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when screening application."
		redirect_to_back
	end

	def by_pass_application_screenings_wizard
		# uncomment the above step to revert back
		# changes to by pass application screenings wized - begin
		application_screening_object = ApplicationScreening.manage_application_screening(session[:APPLICATION_ID])
		session[:NEW_APPLICATION_SCREENING_ID] = application_screening_object.id
		primary_applicant_collection = ApplicationMember.get_primary_applicant(params[:application_id].to_i)
		if primary_applicant_collection.present?
			session[:PRIMARY_APPLICANT] = primary_applicant_collection.first.client_id
		end
		session[:APPLICATION_SCREENING_STEP] = "application_screening_last"
		redirect_to start_check_program_eligibility_wizard_path(session[:APPLICATION_ID])
	end




	private

		def client_doc_verification_params
			params.require(:client_doc_verfication).permit(:client_id, :document_type,:document_verfied_date)
  	 	end

  	 	def client_select_service_program_params
			params.require(:client_application).permit(:application_disposition_status, :application_disposition_reason, :program_unit_processing_location)
  	 	end




  	 	def save_service_program(arg_application_id,arg_params,arg_rails_params)

  	 		ls_msg = ""
  	 		@application_disposition_types = CodetableItem.item_list(127," Application Disposition status")
	      	@application_disposition_reasons = CodetableItem.item_list(66,"Application Disposition List")
  	 		@application_screening_error = SystemParam.new # place holder error object
  	 		@application_screening_error.description = ""
  	 		data_entry_validation = false
  	 		alert_message = ""
	  	 		if arg_params[:application_disposition_status].present? && arg_params[:application_disposition_reason].present?
	  	 			if arg_params[:application_disposition_status].to_i == 6017 # Accepted.
	  	 				if arg_rails_params[:service_program_ids].present? && arg_params[:program_unit_processing_location].present?
	  	 					data_entry_validation = true
	  	 				else
	  	 					data_entry_validation = false
	  	 					unless arg_rails_params[:service_program_ids].present?
	  	 						@application_screening_error.errors[:base] << "Service program is required when application is accepted."
	  	 					end
	  	 					unless arg_params[:program_unit_processing_location].present?
	  	 						@application_screening_error.errors[:base] << "Processing office is required when application is accepted."
	  	 					end
	  	 				end
	  	 			else
	  	 				data_entry_validation = true
	  	 			end
	  	 		else
	  	 			data_entry_validation = false
	  	 			if arg_params[:application_disposition_status].present?
	  	 			else
	  	 				@application_screening_error.errors[:base] << "Action is required."
	  	 			end

	  	 			if arg_params[:application_disposition_reason].present?
	  	 			else
	  	 				@application_screening_error.errors[:base] << "Disposition reason is required."
	  	 			end

	  	 		end
	 		#  Data entry validations are passed proceed to save
  	 		if data_entry_validation == true
  	 			l_service_program_array = arg_rails_params[:service_program_ids]
  	 			begin
					ActiveRecord::Base.transaction do
						method_return_hash = {}
		  	 			method_return_hash = ClientApplication.save_application_action_and_service_programs(arg_params,arg_application_id,l_service_program_array)
		  	 			message = method_return_hash[:message]
		  	 			if message == "SUCCESS"

		 	 				#  Delete the Application screening temporary record - created to persist the steps.
							# @application_screening.destroy
							#  All steps completed -reset session variables.
							session[:APPLICATION_SCREENING_STEP] = session[:NEW_APPLICATION_SCREENING_ID] =  nil
							ls_flash_message = "Service programs Saved."

							primary_applicant_collection = ApplicationMember.get_primary_applicant(arg_application_id)
		          			primary_applicant_object = primary_applicant_collection.first
		          			client_object = Client.find(primary_applicant_object.client_id)

							# Manoj 07/06/2015 - start - # Creation of Work Task - start
							program_unit_collection = ProgramUnit.where("client_application_id = ?",arg_application_id)
							ls_msg = ""
		    				if program_unit_collection.present?

		    					program_unit_collection.each do |each_pgu_object|
						    			# Manoj 09/16/2015 - start - # Creation of WORK QUEUE RECORD -start
						    			# Commented above code - as assignment of work task to LOcal office will be not needed - instead we create records in QUeue and users/supervisors subscribe to queues can take action themselves.
						    			common_action_argument_object = CommonEventManagementArgumentsStruct.new
							            common_action_argument_object.event_id = 243
							            common_action_argument_object.queue_reference_type = 6345 # program unit
            							common_action_argument_object.queue_reference_id = each_pgu_object.id
            							common_action_argument_object.client_application_id = arg_application_id

							            # step2: call common method to process event.
							            ls_msg = EventManagementService.process_event(common_action_argument_object)
							            if ls_msg != "SUCCESS"

							            	break
							            end

		    					end
							else

								if arg_params[:application_disposition_status].to_i == 6018
									# step1 : Populate common event management argument structure
									common_action_argument_object = CommonEventManagementArgumentsStruct.new
						            common_action_argument_object.event_id = 243
					                common_action_argument_object.client_id = client_object.id
					                common_action_argument_object.selected_app_action = arg_params[:application_disposition_status].to_i
					                common_action_argument_object.app_action_reason = arg_params[:application_disposition_reason].to_i

						            # step2: call common method to process event.
						            ls_msg = EventManagementService.process_event(common_action_argument_object)
									# fail
								end
					        end
					        redirect_url = client_applications_path(params[:application_id])
					        if ls_msg == "SUCCESS"
	    						if arg_params[:application_disposition_status].to_i == 6017
	    							ls_flash_message = "Program Units created for selected service programs."
	    							redirect_url = alerts_path
	    						else
	    							ls_flash_message = "Application rejected."
	    						end
						        flash[:notice] = ls_flash_message
						    else
						    	if arg_params[:application_disposition_status].to_i == 6017
						    		ls_flash_message = "#{ls_msg}, Failed to create program units for selected service programs."
						    	else
						    		ls_flash_message = "#{ls_msg}, Failed to reject application."
						    	end

						       	flash[:alert] = ls_flash_message
						       	# Take it to Index page - where it will show Disposition Status as Accepted.
							end

							# redirect_to client_applications_path(params[:application_id])
							redirect_to redirect_url

							# Manoj 07/06/2015 - end
		  	 			else

		  	 				flash[:alert] = message
		  	 				redirect_to start_check_program_eligibility_wizard_path(arg_application_id)
		  	 			end

					end
				rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("ApplicationScreeningController","save_service_program",err,AuditModule.get_current_user.uid)
					lb_saved = false
					ls_msg = "Failed to create service programs - for more details refer to Error ID: #{error_object.id}."
					flash[:alert] = ls_msg
					redirect_to start_check_program_eligibility_wizard_path(arg_application_id)
				end
  	 		else
  	 			if session[:APPLICATION_SCREENING_STEP] == "application_screening_last"
  	 				last_step_objects()
  	 			end
  	 			@selected_application.application_disposition_status = arg_params[:application_disposition_status]
  	 			@selected_application.program_unit_processing_location = arg_params[:program_unit_processing_location]
	  	 		render :start_check_program_eligibility_wizard
  	 		end


  	 	end


  	 def last_step_objects()
			primary_applicant_collection = ApplicationMember.get_primary_applicant(@selected_application.id)
			if primary_applicant_collection.present?
				l_primary_applicant = primary_applicant_collection.first.client_id
			end

			@srvc_prgm_to_be_displayed = {}
			srvc_prgm_array = []
			message_array = []

				# Get service programs for TANF Group
				# As we keep adding other service programs - 6015 needs to be removed and modified later.
				tanf_srvc_prgm_collection = ServiceProgram.get_service_programs_for_category_id(6015)
				tanf_srvc_prgm_collection.each do |arg_srvc_prgm|
					ls_result = ProgramEligibilityService.check_program_eligibility(arg_srvc_prgm.id, l_primary_applicant)
					srvc_prgm_array << arg_srvc_prgm.id
					message_array << ls_result
				end

			@srvc_prgm_to_be_displayed[:service_program_id] = srvc_prgm_array
			@srvc_prgm_to_be_displayed[:message] = message_array

  			any_srvc_prgm_eligible = false
  			@srvc_prgm_to_be_displayed[:message].each do |arg_srvc_msg|
  				if arg_srvc_msg == "Eligible"
  					any_srvc_prgm_eligible = true
  				end
  			end

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

  			if any_srvc_prgm_eligible == true
  				session[:ANY_SERVICE_PROGRAM_ELIGIBLE] = "Y"

  			else
  				session[:ANY_SERVICE_PROGRAM_ELIGIBLE] = "N"


  			end
	end




end
