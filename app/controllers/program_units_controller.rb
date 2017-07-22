class ProgramUnitsController < AttopAncestorController
		#Author :  Manoj
		# Date : 10/12/2014
		# Description : Program Unit management wizard

	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_program_units = ProgramUnit.get_client_program_units(@client.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	# show page.
	def view_program_unit_summary
		populate_summary_instance_variables()
		@current_user = AuditModule.get_current_user
		# what is the Role of the logged in user
		# If user role is supervisor or manager or system support or system Admin or Workload Manager
		# 1;"System Admin"
		# 2;"System Support"
		# 5;"Supervisor"
		# 6;"Manager"
		# 8;"Workload Manager"

			# Are there any pending Case Assignment task?
				if WorkTask.case_manager_assignment_task_pending_for_this_program_unit?(@selected_program_unit.id)
					@can_see_assign_case_manager_button = true

				else
					@can_see_assign_case_manager_button = false
				end


		if WorkTask.eligibility_worker_assignment_task_pending_for_this_program_unit?(@selected_program_unit.id)
			@can_see_assign_eligibility_worker_button = true

		else
			@can_see_assign_eligibility_worker_button = false
		end


		if @selected_program_unit.eligibility_worker_id.present?

			@can_see_start_button = true
		else
			@can_see_start_button = false
		end


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","view_program_unit_summary",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when attempted to access program unit."
		redirect_to_back
	end


	def edit_program_unit_wizard_initialize
		# Initialize wizard
		# called from Complete Program Unitbutton.
		session[:PROGRAM_UNIT_STEP] =  session[:PRIMARY_APPLICANT] = session[:PGU_SAME_AS_APP] = nil
		program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		# PrimaryContact.get_primary_contact(@selected_program_unit.id, 6345)
		# if primary_applicant_collection.present?
		# 	session[:PRIMARY_APPLICANT] = primary_applicant_collection.first.client_id
		# end
		primary_applicant = ApplicationMember.get_primary_applicant(program_unit.client_application_id)
		session[:PRIMARY_APPLICANT] = primary_applicant.client_id if primary_applicant.present?
		redirect_to edit_program_unit_wizard_path(params[:program_unit_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","edit_program_unit_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error when attempted to edit program unit."
		redirect_to_back
	end


	def edit_program_unit_wizard
		objects_required_for_edit_program_unit_wizard(params[:program_unit_id].to_i)
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","edit_program_unit_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when completing program unit."
		redirect_to_back
	end

	def update_program_unit_wizard
		# Placeholder for all PUT request for edit_program_unit_wizard
		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.
		# Rule 3 - After Processing is done send it back to start_check_program_eligibility_wizard - because that is where
		# views corresponding to each step is opened.
		# similar to UPDATE REST action.
		# Common Instance variables for all steps
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_unit_members = @selected_program_unit.program_unit_members
		# primary_beneficiary_object = ProgramUnitMember.get_primary_beneficiary(@selected_program_unit.id)
		primary_beneficiary_object = PrimaryContact.get_primary_contact(@selected_program_unit.id, 6345)
      	if primary_beneficiary_object.present?
      		# virtual attribute storing Primary Applicant
      		# @selected_program_unit.beneficiary_client_id = primary_beneficiary_object.first.client_id
      		@selected_program_unit.beneficiary_client_id = primary_beneficiary_object.client_id
      	end

		#  first step is assigned to current step -when session[:PROGRAM_UNIT_STEP] is null
      	@selected_program_unit.current_step = session[:PROGRAM_UNIT_STEP]

      	# Manage steps -start
      	if params[:back_button].present?
      		 @selected_program_unit.previous_step
      	elsif @selected_program_unit.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @selected_program_unit.next_step
        end
       session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
       # Manage steps -end

       # PGU same as APP Unit?
        if session[:PGU_SAME_AS_APP].present?
			@selected_program_unit.pgu_family_comp_same_as_application = session[:PGU_SAME_AS_APP]
		else
			@selected_program_unit.pgu_family_comp_same_as_application = "Y"
		end

         # what step to process?
		if @selected_program_unit.get_process_object == "program_unit_first" && params[:next_button].present?

			# Choose processing office
			l_params = processing_office_params
			if l_params[:processing_location].present?
				# message = ProgramUnitMember.update_program_unit_primary_beneficiary(@selected_program_unit.id,l_params[:beneficiary_client_id].to_i)
				@selected_program_unit.processing_location = l_params[:processing_location].to_i
				if  @selected_program_unit.save
					# flash[:notice] = "Processing Location Saved"
				else
					flash[:alert] = "Failed to save the processing location."
				end
				@selected_program_unit.pgu_family_comp_same_as_application = l_params[:pgu_family_comp_same_as_application]
				session[:PGU_SAME_AS_APP] = l_params[:pgu_family_comp_same_as_application]

				if session[:PGU_SAME_AS_APP] == "Y"
					@selected_program_unit.current_step = "program_unit_third"
					@selected_program_unit.process_object = "program_unit_first"
					session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				end
				redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)

			else
				@selected_program_unit.previous_step
				session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
		 		@selected_program_unit.errors[:base] << "Processing office is required."
		 		render :edit_program_unit_wizard
			end


		elsif @selected_program_unit.get_process_object == "program_unit_second" && params[:next_button].present?
			# @selected_program_unit.pgu_family_comp_diff_from_application = "Y"
			# session[:PGU_SAME_AS_APP] = "Y"
			# Application Member step
			l_count = ProgramUnitMember.program_unit_member_count(@selected_program_unit.id)
			if l_count >= 2
				redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
			else
					# go back to previous step and show flash message as error message
		 		@selected_program_unit.previous_step
		 		session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
		 		# flash[:alert] = "Minimum Two members are needed to proceed to Next Step."
		 		# redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
		 		objects_required_for_edit_program_unit_wizard(@selected_program_unit.id)
		 		@selected_program_unit.errors[:base] = "Minimum two members are needed to proceed to next step."
		 		render :edit_program_unit_wizard
			end


		elsif @selected_program_unit.get_process_object == "program_unit_third" && params[:next_button].present?
			l_params = primary_beneficiary_params

			if l_params[:beneficiary_client_id].present?
				message = ProgramUnitMember.update_program_unit_primary_beneficiary(@selected_program_unit.id,l_params[:beneficiary_client_id].to_i)
					if  message == "SUCCESS"
						@selected_program_unit.beneficiary_client_id = l_params[:beneficiary_client_id].to_i
	                    # MANOJ -09/16/2014 - SAVING SELF OF APPLICATION IN THE SESSION[:CLIENT_ID] so that headings are shown properly.
						session[:CLIENT_ID] = @selected_program_unit.beneficiary_client_id

						if session[:PGU_SAME_AS_APP] == "Y"
							@selected_program_unit.current_step = "program_unit_last"
							@selected_program_unit.process_object = "program_unit_second"
							session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
						end
						 redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)

					else
						@selected_program_unit.previous_step
		 		        session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
		 		        @selected_program_unit.errors[:base] << "Failed to save the primary member - #{message}."
		 		        render :edit_program_unit_wizard
					end

			else
				@selected_program_unit.previous_step
		 		session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
		 		@selected_program_unit.errors[:base] << "Primary member is required."
		 		render :edit_program_unit_wizard
			end

			# Move to Last Step -test -start

			# @selected_program_unit.current_step = "program_unit_last"
		 # 	session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step

			# Move to Last Step -test -end


		elsif @selected_program_unit.get_process_object == "program_unit_fourth" && params[:next_button].present?
			# check if relations are added?
			l_members_count = @selected_program_unit.program_unit_members.count
			l_expected_relationship_count = l_members_count * (l_members_count - 1)
			# l_db_relationships = ClientRelationship.get_relationship_maintenance_index_list(@client.id)

			@program_unit_member_relationships = ClientRelationship.get_program_unit_member_relationships(@selected_program_unit.id)
			l_db_relationship_count = @program_unit_member_relationships.size

			if l_expected_relationship_count == l_db_relationship_count
				redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
			else
				# go back to previous step and show flash message as error message
				@selected_program_unit.previous_step
				session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
		 		@selected_program_unit.errors[:base] << "All relationships between members do not exist, add missing relationships."
		 		render 'edit_program_unit_wizard'
		 		#redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
			end



		elsif @selected_program_unit.get_process_object == "program_unit_fifth" && params[:next_button].present?
			# check from displayed Data validations - All Records should Say - VALID - Then Only Proceed to Next Step.
			# Call Data Validation Service Object.
      		application_srvc_object = ApplicationDataValidationService.new
			application_srvc_object.validate_program_unit_members_data_elements(@selected_program_unit.id)
			# get records from Datavalidation table for selected application ID
			data_validation_results = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@selected_program_unit.id)
			all_valid = true
			if data_validation_results.size > 0
				# Manoj 10/29/2014 - Education is not manadatory fix for Approval - he can be sanctioned later - hence this is only information.
				 data_validation_results.each do |arg_validation|
					if arg_validation.data_item_type == 6051 #'EDUCATION'
						all_valid = true
					else
						if arg_validation.result == false
							all_valid = false
							break
						end
					end

				 end
			end
			if all_valid == true

				if session[:PGU_SAME_AS_APP] == "Y"
					@selected_program_unit.current_step = "program_unit_last"
					@selected_program_unit.process_object = "program_unit_second"
					session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				end
				redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
			else

				@selected_program_unit.previous_step
				session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				# flash[:alert] = "Correct All Data Validation errors to Proceed to next Step"
				objects_required_for_edit_program_unit_wizard(@selected_program_unit.id)
				@selected_program_unit.errors[:base] = "Correct all data validation errors to proceed to next step."
				render :edit_program_unit_wizard
			end

			# redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)

		elsif @selected_program_unit.get_process_object == "program_unit_sixth" && params[:next_button].present?
			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)


		elsif @selected_program_unit.get_process_object == "program_unit_seventh" && params[:next_button].present?

			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)

		elsif @selected_program_unit.current_step == "program_unit_last"
			if session[:PGU_SAME_AS_APP] == "Y"
				@selected_program_unit.current_step = "program_unit_last"
				@selected_program_unit.process_object = "program_unit_last"
				session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
			end
			# complete_program_unit(@selected_program_unit.id)
			msg = ProgramUnit.complete_program_unit_process(@selected_program_unit.id)
			if msg == "SUCCESS"
  	 			primary_contact = PrimaryContact.get_primary_contact_for_application(session[:APPLICATION_ID])
  	 			begin
					ActiveRecord::Base.transaction do
						ProgramUnitService.determine_case_type_for_program_unit_and_update(@selected_program_unit)
						if session[:APPLICATION_ID].present?
							# client_application = ClientApplication.find(session[:APPLICATION_ID])
							# client_application.application_status = 5942
							# client_application.save!
							# if program_units.present?
							# 	program_units.each do |program_unit|
									common_action_argument_object = CommonEventManagementArgumentsStruct.new
								 	common_action_argument_object.event_id = 925
								 	# for queue movement
								 	common_action_argument_object.queue_reference_type = 6345 # program unit
								 	common_action_argument_object.queue_reference_id = @selected_program_unit.id
								 	# for work task creation
								 	common_action_argument_object.program_unit_id = @selected_program_unit.id
						 			common_action_argument_object.client_id = primary_contact.client_id
								 	common_action_argument_object.client_application_id = @selected_program_unit.client_application_id
								 	ls_msg = EventManagementService.process_event(common_action_argument_object)
								 	if ls_msg != "SUCCESS"
								 		break
							     	end
								# end
							# end
						end
					end
				# rescue => err
				# 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","update_program_unit_wizard",err,AuditModule.get_current_user.uid)
				# 	ls_msg = "Failed to move selected programs units into ED queue - for more details refer to Error ID: #{error_object.id}"
				end
				redirect_to alerts_path,notice: "Program unit is ready for eligibility determination."
  	 		else
  	 			flash[:alert] = "Program unit completion failed - #{msg}"
  	 			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
  	 		end

		else
			# previous button is clicked.
			# Managesession[:PGU_SAME_AS_APP] == "N" scenario
			if session[:PGU_SAME_AS_APP] == "Y"
				if @selected_program_unit.current_step == "program_unit_seventh"
					@selected_program_unit.current_step = "program_unit_fourth"
					session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				end
				if @selected_program_unit.current_step == "program_unit_fourth"
					@selected_program_unit.current_step = "program_unit_third"
					session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				end
				if @selected_program_unit.current_step == "program_unit_second"
					@selected_program_unit.current_step = "program_unit_first"
					session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				end

			end

			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","update_program_unit_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when completing and updating program unit."
		redirect_to_back
	end



	def destroy_program_unit_member
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		ProgramUnitMember.delete_member(params[:id])
		flash[:alert] = "Program Unit Member Deleted Successfully!"
		redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","destroy_program_unit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when deleting program unit member."
		redirect_to_back
	end

	def program_unit_member_search

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		#  Rule : Add Member - has to force user to first search if the member is already in the system. If he is not found then he can add new member.
		#         New member means = new client + same client_id added in program_unit_members against program Unit ID.
		@show_add_button = false
		@client = Client.new
		session[:NAVIGATED_FROM] = edit_program_unit_wizard_path(@selected_program_unit.id)

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","program_unit_member_search",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when searching for program unit member."
		redirect_to_back

	end

	def program_unit_member_search_results
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		#  new_member_search - method will call this action.
		# Call search service to search client.
		 l_client_serach_service = SearchModule::ClientSearch.new
		  return_obj = l_client_serach_service.search(params)
	    if return_obj.class.name == "String"

	    	  @show_add_button = true
	    	   # Manoj -09/17/2014
			    # Save SSN in session -so that if user decides to add new client for SSN he did not find - we can prepopulate that SSN.
			    # Save SSN in session -so that if user decides to add new client for SSN he did not find - we can prepopulate that SSN.
			   populate_session_from_params(params)
			    # if params[:ssn].present?
			    # 	session[:NEW_CLIENT_SSN] =  params[:ssn]
			    # end
			 if return_obj == "No results found"
			 	render 'no_data_found_search_results'
			 else
			 	 flash.now[:notice] = return_obj
			 	 render 'program_unit_member_search'
			 end
	    else
	    	# if session[:NEW_CLIENT_SSN].present?
	    	# 	session[:NEW_CLIENT_SSN] = nil

	    	# end
	    	reset_pre_populate_session_variables()
	      # results found
	      @clients = return_obj
	       @show_add_button = false
	        render 'program_unit_member_search'
	    end

	    # show result or error message.
	    # render 'program_unit_member_search'
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","program_unit_member_search_results",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when searching client."
		redirect_to_back
	end


	def set_program_unit_member_in_session

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		# the select button on the search result will call this method.
		# searched client ID is stored in session to be used in Add member page.
	  	session[:MODAL_TARGET_SELECTED_CLIENT_ID] = params[:id]
	    # Navigate to new_member creation path.
	    redirect_to new_program_unit_member_path(@selected_program_unit.id)
	  rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","set_program_unit_member_in_session",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when selecting the member."
		redirect_to_back
	end

	def new_program_unit_member

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		# action to add new members.
		# This action accepts two parameters
		# parameter 1: application_id

		# Routes is setup such that arguments can be passed to conroller actions.

		@client = Client.find(session[:CLIENT_ID])

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@program_unit_member = ProgramUnitMember.new
		@program_unit_member.program_unit_id = @selected_program_unit.id
		@program_unit_member.member_status = 4468 # Active

		if session[:MODAL_TARGET_SELECTED_CLIENT_ID].present?

			# Member is in the system -add it to application_member table.
			@program_unit_member.client_id = session[:MODAL_TARGET_SELECTED_CLIENT_ID].to_i
            # clear the session
            session[:MODAL_TARGET_SELECTED_CLIENT_ID] = nil
            @program_unit_member.member_of_application = "N"
            # save
            if @program_unit_member.save
	  			flash[:notice] = "Program Unit Member added"
	  			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
	  		else
	  			@selected_program_unit.errors[:base] << "Selected client exists in program unit."
	  			@selected_program_unit.current_step = "program_unit_second"
	  			session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
	  			@program_unit_members = @selected_program_unit.program_unit_members
	  			render 'edit_program_unit_wizard'
		 		#flash[:alert] = "Failed to Add Member to Program Unit. #{@program_unit_member.errors.full_messages.last}"
	  		end

	  	else

        	#  member is not found in the system- so add client first and then add it to Application_member table.
        	 # open new new_member page so that user will create new client
        	 @client_for_program_unit_member = Client.new

        	if session[:NEW_CLIENT_SSN].present?
        	 	 @client_for_program_unit_member.ssn =  session[:NEW_CLIENT_SSN]
        	end
        	if session[:NEW_CLIENT_LAST_NAME].present?
	    	 	@client_for_program_unit_member.last_name =  session[:NEW_CLIENT_LAST_NAME]
	    	end
	    	if session[:NEW_CLIENT_FIRST_NAME].present?
	    	 	@client_for_program_unit_member.first_name =  session[:NEW_CLIENT_FIRST_NAME]
	    	end
	    	if session[:NEW_CLIENT_DOB].present?
	    	 	@client_for_program_unit_member.dob =  session[:NEW_CLIENT_DOB]
	    	end
	    	if session[:NEW_CLIENT_GENDER].present?
	    	 	@client_for_program_unit_member.gender =  session[:NEW_CLIENT_GENDER]
	    	end
        	 @client = @client_for_program_unit_member
        end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","new_program_unit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when adding member."
		redirect_to_back
	end

	def create_program_unit_member


		# Post method of new_member

		# Add to clients table
		# Save the New record to Database - INSERT
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@client_for_program_unit_member = Client.new(client_params)
		@client = @client_for_program_unit_member

	  	if @client_for_program_unit_member.save
	  		# Add to application_members table
	  		@program_unit_member = ProgramUnitMember.new
			@program_unit_member.program_unit_id = @selected_program_unit.id
			# add new created client ID
			@program_unit_member.client_id = @client_for_program_unit_member.id
			@program_unit_member.member_of_application = "N"
			@program_unit_member.member_status = 4468 # Active
			# Save Application member.
			@program_unit_member.save

	  		flash[:notice] = "Program unit member added."
	  		if session[:NEW_CLIENT_SSN].present?
	  			 session[:NEW_CLIENT_SSN] = nil

	  		end
	  		redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)

	  	else
	  		render :new_program_unit_member
	  	end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","create_program_unit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when creating program unit member."
		redirect_to_back
	end

	def edit_program_unit_member_multiple_relationship
		@client = Client.find(session[:CLIENT_ID])
		# Check at least Two application members are there to proceed.
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		program_unit_members_collection = @selected_program_unit.program_unit_members
		if program_unit_members_collection.size >= 2 then
			session[:NAVIGATED_FROM] = edit_program_unit_wizard_path(@selected_program_unit .id)

			# @client_multiple_relationships = ClientRelationship.prepare_application_member_relationship_data(params[:application_id].to_i)
			@client_multiple_relationships = ClientRelationship.prepare_program_unit_member_relationship_data_one_direction(@selected_program_unit.id)
		else
			# flash[:alert] = "Minimum Two Program Unit Members are needed to setup relationship between them"
			# redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
			objects_required_for_edit_program_unit_wizard(@selected_program_unit.id)
			@selected_program_unit.errors[:base] = "Minimum two program unit members are needed to setup relationship between them."
			render :edit_program_unit_wizard
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","edit_program_unit_member_multiple_relationship",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when editing relationships."
		redirect_to_back
	end

	def update_program_unit_member_multiple_relationship
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@client_multiple_relationships = ClientRelationship.prepare_program_unit_member_relationship_data_one_direction(@selected_program_unit.id)
		l_params = multiple_relationships_params
     	if all_relationship_types_populated?(l_params) == true
     		# Manoj Testing 09/22/2014
     		# @client_multiple_relationships = ClientRelationship.update_multiple_relationships(l_params)
     		@client_multiple_relationships = ClientRelationship.update_multiple_relationships_with_inverse_relation(l_params)
			msg = "SUCCESS"
     		@client_multiple_relationships.each do |arg_reln|
				if arg_reln.errors.any?
					msg = "FAIL"
					break
				end
			end
			if msg == "SUCCESS"
				flash[:notice] = "All program unit member relationships saved successfully."
     			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
			else
				render 'edit_program_unit_member_multiple_relationship'
			end
     	else
     		# Rails.logger.debug("client_multiple_relationships = #{@client_multiple_relationships.inspect}")
     		# fail
     		# flash[:alert] = "All Relationship type are not populated"
			# render :edit_application_member_multiple_relationship
			@client_relationship_errors = ClientRelationship.new
     		@client_relationship_errors.errors[:base] = "All relationship type are not populated."
			# render :edit_application_member_multiple_relationship
			li = 0
			@client_multiple_relationships.each do |arg_reln|
				# steps.index(current_step)
				l_hash = l_params[li]
				arg_reln.relationship_type = l_hash[:relationship_type]
				li = li + 1
			end
			# logger.debug "UPDATE - second-@client_multiple_relationships -inspect = #{@client_multiple_relationships.inspect}"
			render 'edit_program_unit_member_multiple_relationship'
			# redirect_to edit_application_member_multiple_relationship_path(session[:new_application_id].to_i,"WIZARD")
     	end
    rescue => err
    	error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","update_program_unit_member_multiple_relationship",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when updating relationships."
		redirect_to_back

	end

	def new_program_unit_verification_document

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@selected_program_unit.id)

		@client_doc_verification = ClientDocVerfication.new
	 rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","new_program_unit_verification_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when adding verification document."
		redirect_to_back

	end

	def create_program_unit_verification_document

		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@selected_program_unit.id)
		l_params = client_doc_verification_params
		@client_doc_verification = ClientDocVerfication.new(l_params)
		if @client_doc_verification.save

			flash[:notice] = "Verification document added successfully."
			redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
		else
			render :new_program_unit_verification_document
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","create_program_unit_verification_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when saving verification document."
		redirect_to_back
	end

	def delete_program_unit_verification_document
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@client_doc_verification = ClientDocVerfication.find(params[:document_id])
		@client_doc_verification.destroy
		flash[:alert] = "Selected document deleted successfully."
		redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","delete_program_unit_verification_document",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when deleting verification document."
		redirect_to_back
	end




	def program_unit_screening_correction_link
		session[:PRIMARY_APPLICANT] = session[:CLIENT_ID]
		application_eligibility_result_object = ApplicationEligibilityResults.find(params[:id])

		program_unit_id = params[:program_unit_id]
		session[:CLIENT_ID] = application_eligibility_result_object.client_id

		if params[:called_from] == "PROGRAM_UNIT_WIZARD"
			session[:NAVIGATE_FROM] = edit_program_unit_wizard_path(program_unit_id)

		elsif params[:called_from] == "PROGRAM_UNIT_SCREENING_RESULTS_SHOW"
			session[:NAVIGATE_FROM] = program_unit_data_validation_results_path(program_unit_id)
		elsif params[:called_from] == "PROGRAM_UNIT_SCREENING_LAST_STEP"
			session[:NAVIGATE_FROM] = edit_program_unit_wizard_path(program_unit_id)
		elsif params[:called_from] == "PROGRAM_UNIT_OVERWRITE"
			session[:NAVIGATE_FROM] = start_overwrite_wizard_path(program_unit_id)
		else
			session[:NAVIGATE_FROM] = show_program_unit_screening_result_path(program_unit_id)
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
				redirect_to living_arrangement_path("program_unit", program_unit_id)
			when 6088 #"State Residence"
				redirect_to show_alien_path(params[:id])
			when 6089 #"Citizenship or Eligible Alien"
				redirect_to show_alien_path(params[:id])
			when 6337 #"Mandatory Work Participation requirement"
				redirect_to index_client_characteristic_path("clients","work")
			when 6570
				redirect_to employments_path("CLIENT")
			when 6765 #"Physical Address not verified"
				redirect_to show_contact_information_path
			when 6752 # 'Legal'
				redirect_to index_client_characteristic_path("clients","legal")
			when 6754 # 'Race'
				redirect_to show_race_path
			when 6753 #"Outs of state payments"
				redirect_to out_of_state_payments_path
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","program_unit_screening_correction_link",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when accessing data fix link."
		redirect_to_back
	end


	def edit_assign_case_manager
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@case_manager_list = User.all
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","edit_assign_case_manager",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when assigning case manager."
		redirect_to_back
	end

	def update_assign_case_manager
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@case_manager_list = User.all
		l_params = assign_case_manager
		if l_params[:case_manager_id].present?
			@selected_program_unit.case_manager_id = l_params[:case_manager_id]

			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	        # common_action_argument_object.event_id = 6501 # "Eligible for Planning event"
	        # common_action_argument_object.program_unit_id = @selected_program_unit.id
	        common_action_argument_object.client_id = @client.id
	        common_action_argument_object.model_object = @selected_program_unit
	        common_action_argument_object.changed_attributes = @selected_program_unit.changed_attributes().keys
		 	begin
				ActiveRecord::Base.transaction do
					# ls_message = WorkTask.complete_case_assignment_task(@selected_program_unit)
					# step2
					ls_msg = EventManagementService.process_event(common_action_argument_object)
					if ls_msg == "SUCCESS"
						@selected_program_unit.save!
						flash[:notice] = "Task completed successfully."
						# redirect_to work_tasks_path
						redirect_to view_program_unit_summary_path(@selected_program_unit)
					else
						flash[:alert] = ls_msg
						render :edit_assign_case_manager
					end

				end
			rescue => err
						error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitssController","update_assign_case_manager",err,current_user.uid)
						flash[:alert] = "Error occurred when updating case manager for more details refer to error ID: #{error_object.id}."
						redirect_to view_program_unit_summary_path(@selected_program_unit)
			end

		else
			@selected_program_unit.errors[:base] << "Case manager is required."
			render :edit_assign_case_manager
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","update_assign_case_manager",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when assigning case manager."
		redirect_to_back
	end

	def edit_assign_eligibility_worker
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@case_manager_list = User.all
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","edit_assign_eligibility_worker",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when assigning eligibitity worker."
		redirect_to_back
	end

	def update_assign_eligibility_worker

		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@case_manager_list = User.all
		l_params = assign_eligibility_worker
		if l_params[:eligibility_worker_id].present?
			@selected_program_unit.eligibility_worker_id = l_params[:eligibility_worker_id]
			begin
				ActiveRecord::Base.transaction do
					# step1 : Populate common event management argument structure
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        # common_action_argument_object.event_id = 6502 #
			        # common_action_argument_object.program_unit_id = @selected_program_unit.id
			        common_action_argument_object.client_id = @client.id
			        common_action_argument_object.model_object = @selected_program_unit
			        common_action_argument_object.changed_attributes = @selected_program_unit.changed_attributes().keys
			        # step2
					ls_msg = EventManagementService.process_event(common_action_argument_object)
					Rails.logger.debug("update_assign_eligibility_worker ls_msg = #{ls_msg}")
					if ls_msg == "SUCCESS"
						if @selected_program_unit.save!
							flash[:notice] = "Task completed successfully."
						else
							flash[:alert] = "Save failed."
						end
						# redirect_to work_tasks_path
						redirect_to view_program_unit_summary_path(@selected_program_unit)
					else
						flash[:alert] = ls_msg
						render :edit_assign_eligibility_worker
					end
				end
			rescue => err
						error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitssController","update_assign_eligibility_worker",err,current_user.uid)
						flash[:alert] = "Error occurred when updating eligibility worker for more details refer to error ID: #{error_object.id}."
						redirect_to view_program_unit_summary_path(@selected_program_unit)
			end
		else
			@selected_program_unit.errors[:base] << "Eligibility worker is required."
			render :edit_assign_eligibility_worker
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","update_assign_eligibility_worker",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when assigning eligibitity worker."
		redirect_to_back
	end

	# def work_flow_status_index
	# 	if session[:CLIENT_ID].present?
	# 		@client = Client.find(session[:CLIENT_ID].to_i)
	# 		@client_program_units = ProgramUnit.get_client_program_units(@client.id)
	# 	end
	# end

	def work_flow_status
		@client = Client.find(session[:CLIENT_ID])
        @program_unit_id = params[:program_unit_id].to_i
        unless @program_unit_id == 0
			@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		    state = WorkQueue.get_the_state_of_the_reference_id(6345,@selected_program_unit.id)
	        state_desc = CodetableItem.get_short_description(state)
	            require "graphviz"
	            GraphViz.digraph( :G ) { |g|
	              g[:truecolor => true, :bgcolor => "transparent", :rankdir => ""]

	              nodes_created =[]

	              # set global node options
	              g.node[:color] = "#ddaa66"
	              g.node[:style] = "filled"
	              g.node[:shape] = "box"
	              g.node[:penwidth] = "2"
	              g.node[:fontname] = "Trebuchet MS"
	              g.node[:fontsize] = "8"
	              g.node[:fillcolor]= "#ffeecc"
	              g.node[:fontcolor]= "#000000"
	              g.node[:margin] = "0.0"

	              # set global edge options
	              g.edge[:color] = "#999999"
	              g.edge[:weight] = "1"
	              g.edge[:fontsize] = "6"
	              g.edge[:fontcolor]= "#444444"
	              g.edge[:fontname] = "Verdana"
	              g.edge[:dir] = "forward"
	              g.edge[:arrowsize]= "0.5"

	              WorkQueue.state_machines[:state].events.each do |event|
	              if nodes_created.include?(event.known_states[0]) == false
	                          nodes_created << event.known_states[0]
	                          g.add_node("#{event.known_states[0]}").label = event.known_states[0].to_s.humanize.titleize.strip
	                          if state_desc.to_s.upcase.strip == event.known_states[0].to_s.humanize.titleize.upcase.strip
	                     g.add_node("#{event.known_states[0]}").color = "#004d00"
	                     g.add_node("#{event.known_states[0]}").fillcolor = "#ffffff"
	                  end
	              end

	              if nodes_created.include?(event.known_states[1]) == false
	                        nodes_created << event.known_states[1]
	                        g.add_node("#{event.known_states[1]}").label = event.known_states[1].to_s.humanize.titleize.strip

	                        if state_desc.to_s.upcase.strip == event.known_states[1].to_s.humanize.titleize.upcase.strip
	                     g.add_node("#{event.known_states[1]}").color = "#004d00"
	                     g.add_node("#{event.known_states[1]}").fillcolor = "#ffffff"
	                  end
	              end
	          g.add_edge("#{event.known_states[0]}","#{event.known_states[1]}").label= ""#event.name


	              end


	            }.output(svg: "#{Dir.pwd}/work_flow.svg")
        end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","work_flow_status",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when creating work flow."
		redirect_to_back

	end

	def overwrite_wizard_initialize
		session[:OVERWRITE_WIZARD_STEP] = nil
		# fail
		redirect_to start_overwrite_wizard_path(params[:program_unit_id].to_i)
		# rescue => err
		# 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","overwrite_wizard_initialize",err,current_user.uid)
		# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to start overwrite wizard"
		# 	redirect_to_back
	end

	def start_overwrite_wizard
		@program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@program_unit.overwrite_wizard_current_step = session[:OVERWRITE_WIZARD_STEP]
		@client = Client.find(session[:CLIENT_ID])
		if @program_unit.overwrite_wizard_first_step?
			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@program_unit.id)
			# Rails.logger.debug("@program_unit_members = #{@program_unit_members.inspect}")
			# fail
		elsif @program_unit.overwrite_wizard_second_step?
			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@program_unit.id)
			@label_name = "Primary Member"
			@prompt_msg = "Choose Primary Member"
		elsif @program_unit.overwrite_wizard_third_step?
			application_srvc_object = ApplicationDataValidationService.new
			application_srvc_object.validate_program_unit_members_data_elements(@program_unit.id)
			@data_validation_results = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@program_unit.id)
			# fail
		elsif @program_unit.overwrite_wizard_fifth_step?
			fts = FamilyTypeService.new
			@family_type_struct = FamilyTypeStruct.new
			@family_type_struct = fts.determine_family_type_for_program_unit(@program_unit.id)
			@family_type_struct.application_date = ClientApplication.find(@program_unit.client_application_id).application_date
			@case_type = @family_type_struct.case_type

			appl_eligibilty_servc = ApplicationEligibilityService.new
			appl_eligibilty_servc.determine_program_unit_eligibilty(@family_type_struct)

			@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@family_type_struct.application_id)
			# Rails.logger.debug("@app_elig_rslts = #{@app_elig_rslts.inspect}")
			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@program_unit.id)
			getting_sorted_program_unit_members = ProgramUnitMember.get_program_unit_members(@program_unit.id)
			@app_elig_rslts = @app_elig_rslts.where("application_eligibility_results.client_id in (?)",getting_sorted_program_unit_members.select("program_unit_members.client_id"))
			# Rails.logger.debug("@app_elig_rslts after = #{@app_elig_rslts.inspect}")
			# fail

			if @program_unit.case_type != @family_type_struct.case_type_integer
				# Save new case type
				# save that case type in Application screening table.
				@program_unit.case_type = @family_type_struct.case_type_integer
				@program_unit.save
			end
		elsif @program_unit.overwrite_wizard_last_step?
			@selected_program_unit = @program_unit
			populate_summary_instance_variables()
		end

		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","start_overwite_wizard",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid program unit."
			redirect_to_back
	end

	def process_overwrite_wizard
		@program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@program_unit.overwrite_wizard_current_step = params[:overwrite_wizard_current_step]
		if params[:back_button].present?
      		 @program_unit.overwrite_wizard_previous_step
      	elsif @program_unit.overwrite_wizard_last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
      		# fail
           @program_unit.overwrite_wizard_next_step
        end
        session[:OVERWRITE_WIZARD_STEP] = @program_unit.overwrite_wizard_current_step

		if @program_unit.overwrite_wizard_get_process_object == "overwrite_wizard_first" && params[:next_button].present?
			# fail
	 		redirect_to start_overwrite_wizard_path(@program_unit.id)
		elsif @program_unit.overwrite_wizard_get_process_object == "overwrite_wizard_second" && params[:next_button].present?
			if params[:beneficiary_client_id].present?
				message = ProgramUnitMember.update_program_unit_primary_beneficiary(@program_unit.id,params[:beneficiary_client_id].to_i)
				if  message == "SUCCESS"
					@program_unit.beneficiary_client_id = params[:beneficiary_client_id].to_i
                    # MANOJ -09/16/2014 - SAVING SELF OF APPLICATION IN THE SESSION[:CLIENT_ID] so that headings are shown properly.
					session[:CLIENT_ID] = @program_unit.beneficiary_client_id
					# Rails.logger.debug("@data_validation_results = #{@data_validation_results.inspect}")
					# fail
					redirect_to start_overwrite_wizard_path(@program_unit.id)
				else
					@program_unit.overwrite_wizard_previous_step
	 		        session[:OVERWRITE_WIZARD_STEP] = @program_unit.overwrite_wizard_current_step
	 		        @program_unit.errors[:base] << "Failed to save the primary member - #{message}"
	 		        @client = Client.find(session[:CLIENT_ID])
	 		        @program_unit_members = ProgramUnitMember.sorted_program_unit_members(@program_unit.id)
	 		        render :start_overwrite_wizard
				end
			else
				@program_unit.overwrite_wizard_previous_step
		 		session[:OVERWRITE_WIZARD_STEP] = @program_unit.overwrite_wizard_current_step
		 		@program_unit.errors[:base] << "Primary member is required."
		 		@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@program_unit.id)
		 		render :start_overwrite_wizard
			end
			# fail
			# redirect_to start_overwrite_wizard_path(@program_unit.id)
		elsif @program_unit.overwrite_wizard_get_process_object == "overwrite_wizard_third" && params[:next_button].present?
			@data_validation_results = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@program_unit.id)
			all_valid = true
			if @data_validation_results.size > 0
				# fail
				# Manoj 10/29/2014 - Education is not manadatory fix for Approval - he can be sanctioned later - hence this is only information.
				@data_validation_results.each do |arg_validation|
					if arg_validation.data_item_type == 6051 #'EDUCATION'
						all_valid = true
					else
						if arg_validation.result == false
							all_valid = false
							break
						end
					end

				end
			end
			if all_valid == true
				redirect_to start_overwrite_wizard_path(@program_unit.id)
			else
				@program_unit.overwrite_wizard_previous_step
				session[:OVERWRITE_WIZARD_STEP] = @program_unit.overwrite_wizard_current_step
				@program_unit.errors[:base] = "Correct all data validation errors to proceed to next step."
				render :start_overwrite_wizard
			end
		elsif @program_unit.overwrite_wizard_get_process_object == "overwrite_wizard_fourth" && params[:next_button].present?
			redirect_to start_overwrite_wizard_path(@program_unit.id)
		elsif @program_unit.overwrite_wizard_get_process_object == "overwrite_wizard_fifth" && params[:next_button].present?
			redirect_to start_overwrite_wizard_path(@program_unit.id)
		elsif @program_unit.overwrite_wizard_current_step == "overwrite_wizard_last"
			msg = ProgramUnit.complete_program_unit_process(@program_unit.id)
  	 		if msg == "SUCCESS"
  	 			flash[:notice] = "Program unit completed successfully."
  	 			# redirect_to overwrite_wizard_initialize_path(@program_unit.id)
  	 			redirect_to program_unit_data_validation_results_path(@program_unit.id)
  	 		else
  	 			flash[:alert] = "Program unit completion failed - #{msg}"
  	 			redirect_to start_overwrite_wizard_path(@program_unit.id)
  	 		end
		else
			redirect_to start_overwrite_wizard_path(@program_unit.id)
		end
		rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","process_overwrite_wizard",err,current_user.uid)
				flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing overwrite program unit wizard."
				redirect_to_back
	end

	def edit_program_unit_members
		@program_unit_member = ProgramUnitMember.new
		objects_for_edit_program_unit_members
	end

	def destroy_program_unit_member_over_write_wizard
		@client = Client.find(session[:CLIENT_ID])
		@program_unit = ProgramUnit.find(params[:program_unit_id])
		ProgramUnitMember.delete_member(params[:id])
		flash[:alert] = "Program unit member deleted successfully."
		redirect_to edit_program_unit_members_path(@program_unit.id,params[:from])
		# redirect_to start_overwrite_wizard_path(@program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","destroy_program_unit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when deleting program unit member."
		redirect_to_back
	end

	def add_program_unit_member
		@program_unit_member = ProgramUnitMember.new(params_overwrite_first_step)
		@program_unit_member.program_unit_id = params[:program_unit_id].to_i
		# @program_unit_member.primary_beneficiary = 'N'
		@program_unit = ProgramUnit.find(params[:program_unit_id])
		if @program_unit_member.valid?
			@program_unit_member.save
			if params[:save_and_add].present?
				objects_for_edit_program_unit_members
				render :edit_program_unit_members
			else
				case params[:from]
				when "overwrite"
					redirect_to start_overwrite_wizard_path(@program_unit.id)
				when "screening"
					redirect_to edit_program_unit_wizard_path(@program_unit.id)
				end
			end
		else
			objects_for_edit_program_unit_members
			render :edit_program_unit_members
		end
	end

	def primary_beneficiary
		if PrimaryContact.get_primary_contact_for_program_unit(params[:program_unit_id].to_i).present?
			navigate_to_ebt_representative_or_run_summary
		else
			instances_for_primary_beneficiary
		end
	end

	def add_primary_beneficiary
		if params[:back_button].present?
			redirect_to program_unit_data_validation_results_path(params[:program_unit_id].to_i)
		else
			if params[:beneficiary_client_id].present?
				PrimaryContactService.save_primary_contact(params[:program_unit_id].to_i, 6345, params[:beneficiary_client_id].to_i)
				navigate_to_ebt_representative_or_run_summary
			else
				instances_for_primary_beneficiary
				@selected_program_unit.errors[:base] << "Please select #{@label_name}."
				render :primary_beneficiary
			end
		end
	end

	private

		def all_relationship_types_populated?(arg_params)
			l_return = true
			arg_params.each do |arg_param|
				if arg_param[:relationship_type].blank?
					l_return = false
					break
				end
			end
			return l_return
		end

		# def params_first_step
		# 	params.require(:program_unit).permit(:processing_location,:disposition_status,:disposition_reason)
		# end

		def client_params
			params.require(:client).permit(:first_name, :middle_name,:last_name,:suffix,:ssn,:dob,:gender,:marital_status,:primary_language,:ssn_enumeration_type,:identification_type,:ssn_not_found)
  		end

  		# Allowing Arrays through STRONG PARAMETER
#   	[{number:"1234",client_id:"11"},{{number:"1235",client_id:"11"}},{{number:"1444",client_id:"11"}}]
#   	we have to reach the hash inside Array and permit them.
	  	def multiple_relationships_params
		  params.require(:relationships).map do |p|
		     ActionController::Parameters.new(p.to_hash).permit(:relationship_type,:from_client_id,:to_client_id,:update_flag)
		   end
		end

		def client_doc_verification_params
			params.require(:client_doc_verfication).permit(:client_id, :document_type,:document_verfied_date)
  	 	end

  	 	def primary_beneficiary_params
 			params.require(:program_unit).permit(:beneficiary_client_id)
 		end

 		# def program_unit_close_params
  	#  		params.require(:program_unit_participation).permit(:reason,:action_date)
  	#  	end

  	 	def processing_office_params
  	 		params.require(:program_unit).permit(:processing_location,:pgu_family_comp_same_as_application)
  	 	end

  	 	# def program_unit_denial_params
  	 	# 	params.require(:program_unit).permit(:disposition_reason)
  	 	# end

  	 	def assign_case_manager
			params.require(:program_unit).permit(:case_manager_id)
		end

		def assign_eligibility_worker
			params.require(:program_unit).permit(:eligibility_worker_id)
		end



  	 	def populate_summary_instance_variables()

  	 		#1. Program Unit
			# 2. Program Unit Members
			# 3. Program Unit member relationship
			# 4.Program Unit Data Verification Results
			# 5. Program Unit Document Verification Results
			# 6. Program Unit Screening Results
			# 7.Program Participation Status
			@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
			# Manoj 04/22/2015
			# When Navigated from My Program Units there will not be Client_id in the session - hence logically setting the correct client id in the session.
			if session[:CLIENT_ID].present?
				@client = Client.find(session[:CLIENT_ID])
			else
				# find the self of program unit & if it is not yet poplated - find the primary applicant
				# and populate session[:CLIENT_ID]

				# primary_member_collection = ProgramUnitMember.get_primary_beneficiary(@selected_program_unit.id)
				# if primary_member_collection.present?
				# 	self_of_pgu_object = primary_member_collection.first
				# 	session[:CLIENT_ID] = self_of_pgu_object.client_id
				# else
				# 	# find primary Applicant
				# 	primary_applicant_collection = ApplicationMember.get_primary_applicant(@selected_program_unit.client_application_id)
				# 	primary_applicant_object = 	primary_applicant_collection.first
				# 	session[:CLIENT_ID] = primary_applicant_object.client_id
				# end

				primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.id, 6345)
				if primary_contact.blank?
					primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.client_application_id, 6587)
				end
				if primary_contact.present?
					session[:CLIENT_ID] = primary_contact.client_id
				end
				@client = Client.find(session[:CLIENT_ID])
			end



			# Initialize the Session Variable -start - Manoj 10/09/2014
			session[:PROGRAM_UNIT_ID] = @selected_program_unit.id
			# Initialize the Session Variable -start
			@client_application = ClientApplication.find(@selected_program_unit.client_application_id)
			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@selected_program_unit.id)
			@client_relationships = ClientRelationship.get_program_unit_member_relationships(@selected_program_unit.id)
			# Call Data Validation Service Object.
      		application_srvc_object = ApplicationDataValidationService.new
			application_srvc_object.validate_program_unit_members_data_elements(@selected_program_unit.id)
			# get records from Datavalidation table for selected application ID
			@data_validation_results = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@selected_program_unit.id)
			# @data_validation_results = DataValidation.get_data_validation_results(@client_application.id)
			@client_doc_verification_list = ClientDocVerfication.get_program_unit_verified_documents(@selected_program_unit.id)


			fts = FamilyTypeService.new
			@family_type_struct = FamilyTypeStruct.new
			@family_type_struct = fts.determine_family_type_for_program_unit(@selected_program_unit.id)
			@family_type_struct.application_date = @client_application.application_date
			# @case_type = @family_type_struct.case_type
			@case_type = CodetableItem.get_short_description(@selected_program_unit.case_type)
			if DataValidation.are_all_the_date_validations_complete(@selected_program_unit.id, "PU")
				appl_eligibilty_servc = ApplicationEligibilityService.new
				#appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
				appl_eligibilty_servc.determine_program_unit_eligibilty(@family_type_struct)

				# @app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@client_application.id)
				@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list_based_on_program_unit_id(session[:PROGRAM_UNIT_ID].to_i)

			end

			@program_participations = @selected_program_unit.program_unit_participations.order("id DESC")

  	 	end

  	 	# def complete_program_unit(arg_program_unit_id)
  	 	# 	msg = ProgramUnit.complete_program_unit_process(arg_program_unit_id)
  	 	# 	if msg == "SUCCESS"
  	 	# 		flash[:notice] = "Program unit completed successfully."
  	 	# 		# Manoj 10/29/2014 - AFter Program Unit completion proceed to ED first step.
  	 	# 		# redirect_to view_program_unit_summary_path(arg_program_unit_id)
  	 	# 		redirect_to program_unit_eligibility_wizard_initialize_path(arg_program_unit_id)
  	 	# 	else
  	 	# 		flash[:alert] = "Program unit completion failed - #{msg}"
  	 	# 		redirect_to edit_program_unit_wizard_path(@selected_program_unit.id)
  	 	# 	end

  	 	# end


  	 	def populate_session_from_params(arg_param)
	  	 	if arg_param[:ssn].present?
		    	session[:NEW_CLIENT_SSN] =  arg_param[:ssn]
		    end

		     if arg_param[:last_name].present?
		    	session[:NEW_CLIENT_LAST_NAME] =  arg_param[:last_name]
		    end

		     if arg_param[:first_name].present?
		    	session[:NEW_CLIENT_FIRST_NAME] =  arg_param[:first_name]
		    end

		     if arg_param[:dob].present?
		    	session[:NEW_CLIENT_DOB] =  arg_param[:dob]
		    end

		    if arg_param[:gender].present?
		    	session[:NEW_CLIENT_GENDER] =  arg_param[:gender]
		    end
	  	end

	  	def reset_pre_populate_session_variables()
	  	 	if session[:NEW_CLIENT_SSN].present?
	  			session[:NEW_CLIENT_SSN] = nil
	  		end

	  		if session[:NEW_CLIENT_LAST_NAME].present?
	  			session[:NEW_CLIENT_LAST_NAME] = nil
	  		end

	  		if session[:NEW_CLIENT_FIRST_NAME].present?
	  			session[:NEW_CLIENT_FIRST_NAME] = nil
	  		end

	  		if session[:NEW_CLIENT_DOB].present?
	  			session[:NEW_CLIENT_DOB] = nil
	  		end
	  		if session[:NEW_CLIENT_GENDER].present?
	  			session[:NEW_CLIENT_GENDER] = nil
	  		end
	  	end

	  	def objects_required_for_edit_program_unit_wizard(arg_program_unit_id)
	  		# Placeholder for all wizard Edit steps.
			if session[:PRIMARY_APPLICANT].present?
				session[:CLIENT_ID] = session[:PRIMARY_APPLICANT]
				session[:PRIMARY_APPLICANT] = nil
			end

			# common instance variable for all steps

			@client = Client.find(session[:CLIENT_ID])
			@selected_program_unit = ProgramUnit.find(arg_program_unit_id)

			# Default Family composition as same
			if session[:PGU_SAME_AS_APP].present?
				@selected_program_unit.pgu_family_comp_same_as_application = session[:PGU_SAME_AS_APP]
			else
				@selected_program_unit.pgu_family_comp_same_as_application = "Y"
			end


			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)
			# primary_beneficiary_object = ProgramUnitMember.get_primary_beneficiary(@selected_program_unit.id)
	  #     	if primary_beneficiary_object.present?
	  #     		# virtual attribute storing Primary Applicant
	  #     		@selected_program_unit.beneficiary_client_id = primary_beneficiary_object.first.client_id
	  #     	end

	  		primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.id, 6345)
	  		if primary_contact.present?
	  			@selected_program_unit.beneficiary_client_id = primary_contact.client_id
	  		end

			 #  which step object to be shown on the start_check_program_eligibility_wizard.html.erb
	      	@selected_program_unit.current_step = session[:PROGRAM_UNIT_STEP]

	      	# Instantiate corresponding Instance variable to be shown on each step view.
	      	if session[:PROGRAM_UNIT_STEP] == "program_unit_first" || @selected_program_unit.current_step == "program_unit_first"
	      		# step 1 processing Office
			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_second" #|| @selected_program_unit.current_step == "program_unit_first"
				# step 2 - Program Unit Members
				 # @program_unit_members = @selected_program_unit.program_unit_members
			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_third"
				 # step 3- primary beneficiary
				 # @program_unit_members = @selected_program_unit.program_unit_members

			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_fourth"
				 # step 4- Relationship
				# @program_unit_members = @selected_program_unit.program_unit_members
				if @program_unit_members.size == 1
					# For Child Only Case -Mimimum size can be equal to 1
					#  set up empty instance variable.
					@program_unit_member_relationships = ""
				else
					@program_unit_member_relationships = ClientRelationship.get_program_unit_member_relationships(@selected_program_unit.id)
				end
			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_fifth"
				 # step 5- Data Verification
				# Call Data Validation Service Object.
	      		application_srvc_object = ApplicationDataValidationService.new
				application_srvc_object.validate_program_unit_members_data_elements(@selected_program_unit.id)
				# get records from Datavalidation table for selected application ID
				@data_validation_results = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@selected_program_unit.id)

			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_sixth"
				# step 6 - Document Verification
				@client_doc_verification_list = ClientDocVerfication.get_program_unit_verified_documents(@selected_program_unit.id)

			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_seventh"
				# step 7 -Screening results step.

				fts = FamilyTypeService.new
				@family_type_struct = FamilyTypeStruct.new
				@family_type_struct = fts.determine_family_type_for_program_unit(@selected_program_unit.id)
				@family_type_struct.application_date = ClientApplication.find(@selected_program_unit.client_application_id).application_date
				@case_type = @family_type_struct.case_type

				appl_eligibilty_servc = ApplicationEligibilityService.new
				appl_eligibilty_servc.determine_program_unit_eligibilty(@family_type_struct)

				@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@family_type_struct.application_id)

				if @selected_program_unit.case_type != @family_type_struct.case_type_integer
					# Save new case type
					# save that case type in Application screening table.
					@selected_program_unit.case_type = @family_type_struct.case_type_integer
					@selected_program_unit.save

				end

			elsif session[:PROGRAM_UNIT_STEP] == "program_unit_last" || @selected_program_unit.current_step == "program_unit_last"

				# Review/ Summary step.
				populate_summary_instance_variables()
				@selected_program_unit.current_step = "program_unit_last"
				session[:PROGRAM_UNIT_STEP] = @selected_program_unit.current_step
				if session[:PGU_SAME_AS_APP].present?
					@selected_program_unit.pgu_family_comp_same_as_application = session[:PGU_SAME_AS_APP]
				else
					@selected_program_unit.pgu_family_comp_same_as_application = "Y"
				end

			end


			#  which step object to be shown on the start_check_program_eligibility_wizard.html.erb
	      	# @selected_program_unit.current_step = session[:PROGRAM_UNIT_STEP]
	  	end

	  	def params_overwrite_first_step
			params.require(:program_unit_member).permit(:client_id,:member_status)
		end

		def objects_for_edit_program_unit_members
			@program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
			@client = Client.find(session[:CLIENT_ID])
			@household_members = HouseholdMember.get_all_members_in_the_household(session[:HOUSEHOLD_ID])
			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@program_unit.id)
			getting_sorted_program_unit_members = ProgramUnitMember.get_program_unit_members(@program_unit.id)
			@household_members = @household_members.where("client_id not in (?)",getting_sorted_program_unit_members.select("program_unit_members.client_id"))
			@program_unit_member_status = CodetableItem.get_code_table_values_by_system_params((@program_unit.service_program_id).to_s)
			@from = params[:from]
			case params[:from]
			when "overwrite"
				@cancel_url = start_overwrite_wizard_path(@program_unit.id)
			when "screening"
				@cancel_url = edit_program_unit_wizard_path(@program_unit.id)
			end
		end

		def instances_for_primary_beneficiary
			@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
			case_type = nil
			# Rails.logger.debug("@selected_program_unit = #{@selected_program_unit.inspect}")
			if @selected_program_unit.case_type.present?
				case_type = @selected_program_unit.case_type
			else
				fts = FamilyTypeService.new
				family_type_struct = FamilyTypeStruct.new
				family_type_struct = fts.determine_family_type_for_program_unit(@selected_program_unit.id)
				Rails.logger.debug("family_type_struct = #{family_type_struct.inspect}")
				case_type = family_type_struct.case_type_integer
				@selected_program_unit.case_type = case_type
				@selected_program_unit.save
			end
			case case_type
			when 6046,6047
				@label_name = "Primary"
				@program_unit_members = ProgramUnitService.get_parent_list_for_the_program_unit(@selected_program_unit.id)
				@program_unit_members = HouseholdMember.get_all_adults_with_in_household(session[:HOUSEHOLD_ID]) if @program_unit_members.blank?
				@prompt_msg = "Choose Primary"
			when 6048,6049
				@label_name = "Caretaker"
				@program_unit_members = HouseholdMember.get_all_adults_with_in_household(session[:HOUSEHOLD_ID])
				@program_unit_members = HouseholdMember.get_all_parents_with_in_household(session[:HOUSEHOLD_ID]) if @program_unit_members.blank?
				@program_unit_members = HouseholdMember.get_anyone_in_household_over_age_fifteen(session[:HOUSEHOLD_ID]) if @program_unit_members.blank?
				@prompt_msg = "Choose Caretaker"
			else
				@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@selected_program_unit.id)
				@label_name = "Primary"
				@prompt_msg = "Choose Primary"
			end
			primary_contact = PrimaryContact.get_primary_contact_for_program_unit(params[:program_unit_id].to_i)
			@primary_contact = primary_contact.client_id if primary_contact.present?
		end

		def navigate_to_ebt_representative_or_run_summary
			# if the service program is TEA diversion or if the EBT representative is already present do an ED run and redirect to run summary
			program_unit = ProgramUnit.find_by_id(params[:program_unit_id].to_i)
			if program_unit.service_program_id == 3 || ProgramUnitRepresentative.get_all_program_unit_representatives_for_program_unit(params[:program_unit_id].to_i).present?
				program_wizard = ProgramWizardService.by_pass_program_wizard_and_run_ed(params[:program_unit_id].to_i)
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,program_wizard.id)
			else
				redirect_to ebt_representative_path(params[:program_unit_id].to_i)
			end
		end
end