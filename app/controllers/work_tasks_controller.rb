class WorkTasksController < AttopAncestorController

	def index
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@work_tasks =  WorkTask.get_pending_user_tasks(current_user.uid).page(params[:page]).page(params[:work_task]).per(l_records_per_page)
		cl_work_tasks = WorkTask.get_completed_user_tasks(current_user.uid)
		@completed_work_tasks = cl_work_tasks.page(params[:page]).page(params[:completed_task]).per(l_records_per_page)


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid work task."
		redirect_to_back
	end

	def new
		@work_task = WorkTask.new
		@current_user = AuditModule.get_current_user
		@work_task_status = CodetableItem.item_list(185,"Work Task status")
		@work_task_type = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("MANUAL_CREATED_MANUAL_CLOSE",18 )
		@work_task_category = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("WORK_TASK_CATEGORY",166)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - occured during creating new work task."
		redirect_to_back

	end

	def create

		@work_task_status = CodetableItem.item_list(185,"Work Task status")
		@work_task_type = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("MANUAL_CREATED_MANUAL_CLOSE",18 )
		@work_task_category = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("WORK_TASK_CATEGORY",166)
		@current_user = AuditModule.get_current_user
		l_params = worktask_params
		@work_task = WorkTask.new(l_params)
	  	if @work_task.valid?
	  		if l_params[:status].to_i == 6341
	  			# if status = complete then update the complete date
	  			@work_task.complete_date = Date.today
	  		end
	  		@work_task.assigned_by_user_id = @current_user.uid
	  		@work_task.assigned_to_type = 6342 # User.

	  		@work_task.save
	  		flash[:notice] = "Work task information saved."
	      	redirect_to work_task_path(@work_task.id)
	  	else
	  		render :new
	  	end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - occured during creating new work task."
		redirect_to_back
	end

	def edit
		@work_task = WorkTask.find(params[:id])
	  	@current_user = AuditModule.get_current_user
	    @work_task_status = CodetableItem.item_list(185,"Work Task status")
	    @work_task_created = WorkTask.work_task_created_by(@work_task.task_type)
	    @work_task_type = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("MANUAL_CREATED_MANUAL_CLOSE",18 )
		@work_task_category = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("WORK_TASK_CATEGORY",166)

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to edit work task."
		redirect_to_back

	end

	def update
		@work_task = WorkTask.find(params[:id])
		@current_user = AuditModule.get_current_user
		@work_task_status = CodetableItem.item_list(185,"Work Task status")
		@work_task_type = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("MANUAL_CREATED_MANUAL_CLOSE",18 )
		@work_task_category = CodetableItem.get_code_table_values_by_system_params_and_code_table_id("WORK_TASK_CATEGORY",166)
		l_params = worktask_params
		@work_task.assigned_to_id = l_params[:assigned_to_id].present? ? l_params[:assigned_to_id] : @work_task.assigned_to_id
		@work_task.task_category = l_params[:task_category].present? ? l_params[:task_category] : @work_task.task_category
		@work_task.task_type = l_params[:task_type].present? ? l_params[:task_type] : @work_task.task_type
		@work_task.due_date = l_params[:due_date].present? ? l_params[:due_date] : @work_task.due_date
		@work_task.action_text = l_params[:action_text].present? ? l_params[:action_text] : @work_task.action_text
		@work_task.instructions = l_params[:instructions].present? ? l_params[:instructions] : @work_task.instructions
		@work_task.urgency = l_params[:urgency].present? ? l_params[:urgency] : @work_task.urgency
		@work_task.notes = l_params[:notes].present? ? l_params[:notes] : @work_task.notes
		@work_task.status = l_params[:status].present? ? l_params[:status] : @work_task.status
		if @work_task.valid?
			# logger.debug(" l_params[:status]  = #{ l_params[:status] }")
			# @work_task.update(worktask_params)
			if l_params[:status].to_i == 6341
				# logger.debug("In the loop l_params[:status]  = #{ l_params[:status] }")
	  			# if status = complete then update the complete date
	  			if @work_task.task_type == 2154
	  				#reeval task type once completed it should update program unit reeval date to current date .
		  				#transaction start
		  				begin
		                  ActiveRecord::Base.transaction do
		                  	# update_reeval_date(program_unit_id)
		                  	ProgramUnit.update_reeval_date(@work_task.reference_id)
		                  	# delete_reeval_queue(arg_state,arg_reference_type,arg_reference_id)
		                  	WorkQueue.delete_reeval_queue(6615,6345,@work_task.reference_id)
		                  end
                        end
		  				#transaction end
	  			end
	  			@work_task.complete_date = Date.today
	  		elsif (l_params[:status].to_i == 6339 or l_params[:status].to_i == 6340)
	  			@work_task.complete_date = nil
	  		end
	  		# logger.debug("@work_task  = #{ @work_task.inspect }")
	  		@work_task.assigned_by_user_id = @current_user.uid
	  		@work_task.assigned_to_type = 6342 # User.

	  		if @work_task.save
				flash[:notice] = "Work task information saved."
				redirect_to work_task_path(@work_task.id)
			else
				render :edit
			end
		else
	  		render :edit
	  	end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to update work task."
		redirect_to_back

	end

	# def destroy
	# 	rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","destroy",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to delete work task"
	# 	redirect_to_back
	# end

	def show

		@show_work_on_task_button = false
		# @show_navigate_button = false
	    @work_task = WorkTask.find(params[:id])


	    # Rule : If completion of task involves - navigating to only one screen where work can be completed
	    #        then Work on the Task button is shown.
	    # If task involves - user navigating to various screen & non screen related tasks - he will complete the task -
	    #  Fron EDit button he will mark the status as complete.
	    if @work_task.assigned_to_type == 6343
	    	#  Assigned to type = LOcal Office
	    	@show_work_on_task_button = true
	    else
	    	# Task assigned to User.
	    	case  @work_task.task_type
		    when 6346,6593,6387,6605,6607,2172,2142,2138,6633,6464,2168,2154,6530,6718,2140,6469,6470,6736,2155,6766,6386,6388,6576,6635,6785,6786,6787,6788
		    	#"Complete and Activate New Program Unit" -navigate to PGU screen
		    	@show_work_on_task_button = true
		    	# redirect_to work_on_task_path(@work_task.id)
		    # when 2142,2138
		    	#"Complete and Activate New Program Unit" -navigate to PGU screen
		    	# @show_navigate_button = true

	   		end


	    end
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid work task."
		redirect_to_back
	end

	def work_on_task
		li_work_task_id = params[:work_task_id]
		work_task_object = WorkTask.find(li_work_task_id)
		clear_session_variables()
		# assigned to User
		case work_task_object.task_type
	        when 6346
	        	# "Complete program unit and determine eligibility" task
	            session[:CLIENT_ID] = work_task_object.client_id
	            set_household_member_info_in_session(session[:CLIENT_ID])
	            session[:PROGRAM_UNIT_ID] = work_task_object.reference_id
	            # code changes done to by pass the program unit validations - Kiran
	            # redirect_to view_program_unit_summary_path(work_task_object.reference_id)
	            # logger.debug("work_task_object = #{work_task_object.inspect}")
	            # program_wizards = ProgramWizard.get_latest_run_from_program_unit_id(work_task_object.program_unit_id)
	            program_wizards = ProgramWizard.where("program_unit_id = ? and submit_date is null",work_task_object.reference_id).order("id DESC")
	            # logger.debug("program_wizards = #{program_wizards.inspect}")
	            # fail
				if program_wizards.present?
					program_wizard = program_wizards.first
					eligibility_deterimine_results = EligibilityDetermineResult.get_results_list(program_wizard.run_id,program_wizard.month_sequence)
			        if eligibility_deterimine_results.where("program_unit_id is not null").count > 0
			        	# @family_type_struct.family_structure[i].budget_eligible_ind = 'N'
			        	# fail
			        	redirect_to show_program_wizard_run_id_details_path(work_task_object.reference_id,program_wizard.id)
			        else
			        	# fail
			        	# @family_type_struct.family_structure[i].budget_eligible_ind = 'Y'
			        	redirect_to program_unit_data_validation_results_path(work_task_object.reference_id,0)
			        end
			    else
			    	redirect_to program_unit_data_validation_results_path(work_task_object.reference_id,0)
			    end
	        when 2142
	            # "Complete and Activate New Program Unit"
	            session[:CLIENT_ID] = work_task_object.client_id
	            set_household_member_info_in_session(session[:CLIENT_ID])
	            session[:PROGRAM_UNIT_ID] = work_task_object.program_unit_id
	            redirect_to program_unit_data_validation_results_path(work_task_object.program_unit_id)
	            # redirect_to index_eligibility_determination_runs_path(work_task_object.reference_id)
	        when 6635
	        	session[:CLIENT_ID] = work_task_object.client_id
	            set_household_member_info_in_session(session[:CLIENT_ID])
	            session[:PROGRAM_UNIT_ID] = work_task_object.program_unit_id
	            # Get the latest run for the given program unit and redirect him to that particular run.
	            # Because the submit button is available only for the latest tun.
	            run_id = ProgramWizard.get_latest_unsubmitted_run(work_task_object.program_unit_id)
	            run_id = work_task_object.reference_id if run_id.blank?
	            redirect_to show_program_wizard_run_id_details_path(work_task_object.program_unit_id,run_id)
	        when 2138
	            # ED warning follow up task

	            	session[:CLIENT_ID] = work_task_object.client_id
	            	set_household_member_info_in_session(session[:CLIENT_ID])
	            	case work_task_object.beneficiary_type
	           			when 6036 #"Education"
							redirect_to educations_path("CLIENT")
						when 6035 #"Immunization"
							redirect_to show_client_immunization_path("CLIENT")
						when 6037 #"Deprivation"
							redirect_to client_parental_rspabilities_path
						when 6038 #"WorkParticipation"
							redirect_to index_client_characteristic_path("clients","work")
						when 6337 #"Mandatory Work Participation requirement"
							redirect_to index_client_characteristic_path("clients","work")
					end
	            # session[:PROGRAM_UNIT_ID] = work_task_object.reference_id
	            # redirect_to view_program_unit_summary_path(work_task_object.reference_id)
	        when 6736
		        	# "Complete Application Intake
          	 		session[:APPLICATION_ID] = work_task_object.reference_id
          	 		client_application_object = ClientApplication.find(work_task_object.reference_id)
          	 		session[:HOUSEHOLD_ID] = client_application_object.household_id
          	 		if HouseholdMember.get_household_members_with_inhousehold_status(session[:HOUSEHOLD_ID]).present?
          	 		session[:CLIENT_ID] = HouseholdMember.get_household_members_with_inhousehold_status(session[:HOUSEHOLD_ID]).first.client_id
          	 		end

          	 		# session[:CLIENT_ID] = work_task_object.client_id
          	 		# set_household_member_info_in_session(session[:CLIENT_ID])
          	 		# Rule : if it is First Application for the household it will be navigated to Household Intake index page -else it will be navigated to first step of the client application.
          	 		client_application_collection = ClientApplication.where("household_id = ?",session[:HOUSEHOLD_ID].to_i)
          	 		if client_application_collection.present?
          	 			#  Manoj 02/25/2016
          	 			#  Navigate all the time to HH Index - user can click on Proceed to App if he want to go there.
          	 			redirect_to household_index_path
          	 			# if client_application_collection.size == 1
          	 			# 	# household Index page.
          	 			# 	redirect_to household_index_path
          	 			# else
          	 			# 	# second application first step.
          	 			# 	session[:APPLICATION_PROCESSING_STEP] = nil
          	 			# 	redirect_to start_application_processing_wizard_path
          	 			# end
          	 		end
	        when 6593
		        	# "Complete Application Screening" task
          	 		session[:APPLICATION_ID] = work_task_object.reference_id
          	 		client_application_object = ClientApplication.find(work_task_object.reference_id)
          	 		session[:HOUSEHOLD_ID] = client_application_object.household_id
          	 		session[:CLIENT_ID] = HouseholdMember.get_household_members_with_inhousehold_status(session[:HOUSEHOLD_ID]).first.client_id
          	 		# session[:CLIENT_ID] = work_task_object.client_id
          	 		# set_household_member_info_in_session(session[:CLIENT_ID])
          	 		# redirect_to view_screening_summary_path(work_task_object.reference_id)
          	 		session[:APPLICATION_PROCESSING_STEP] = nil
          	 		redirect_to start_application_processing_wizard_path
          	when 6387,6786
		        	# "Complete Assessment task
          	 		session[:CLIENT_ID] = work_task_object.client_id
          	 		set_household_member_info_in_session(session[:CLIENT_ID])
          	 		session[:PROGRAM_UNIT_ID] = work_task_object.program_unit_id
          	 		redirect_to selected_sections_for_short_assessment_path(session[:CLIENT_ID])
          	when 6605,6464,6787
          	 		session[:CLIENT_ID] = work_task_object.client_id
          	 		set_household_member_info_in_session(session[:CLIENT_ID])
	            	session[:PROGRAM_UNIT_ID] = work_task_object.program_unit_id
	            	redirect_to action_plans_path
        	when 6607
        		session[:CLIENT_ID] = work_task_object.client_id
        		set_household_member_info_in_session(session[:CLIENT_ID])
            	session[:PROGRAM_UNIT_ID] = work_task_object.program_unit_id
            	redirect_to show_pending_cpp_path(work_task_object.reference_id)
            when 2172,6388
        		session[:CLIENT_ID] = work_task_object.client_id
        		set_household_member_info_in_session(session[:CLIENT_ID])
        		program_wizard_object = ProgramWizard.find(work_task_object.reference_id)
	           	session[:PROGRAM_UNIT_ID] = program_wizard_object.program_unit_id
	           	redirect_to show_program_wizard_run_id_details_path(program_wizard_object.program_unit_id,program_wizard_object.id)
			when 6633
        		session[:CLIENT_ID] = work_task_object.client_id
        		set_household_member_info_in_session(session[:CLIENT_ID])
        		program_unit_object = ProgramUnit.find(work_task_object.reference_id)
        		# get the latest Run id for this PGU.
        		# Assumption we will navigate to last run id, if it is not the run id user intends
        		#  he can choose other run.
        		program_wizards_collection = ProgramWizard.where("program_unit_id = ?",program_unit_object.id).order("ID DESC")
        		program_wizard_object = program_wizards_collection.first
	           	session[:PROGRAM_UNIT_ID] = program_wizard_object.program_unit_id
	           	redirect_to show_program_wizard_run_id_details_path(program_wizard_object.program_unit_id,program_wizard_object.id)
            when 2168,6788
   	        	session[:CLIENT_ID] = work_task_object.client_id
	        	set_household_member_info_in_session(session[:CLIENT_ID])
	        	sanction_object = Sanction.find(work_task_object.reference_id)
	        	redirect_to sanctions_path(sanction_object.id)
	        when 2154
	        	session[:CLIENT_ID] = work_task_object.client_id
	        	set_household_member_info_in_session(session[:CLIENT_ID])
	        	session[:PROGRAM_UNIT_ID] = work_task_object.reference_id
	        	redirect_to program_unit_data_validation_results_path(work_task_object.reference_id)
	        when 6530
	        	session[:CLIENT_ID] = work_task_object.client_id
	        	set_household_member_info_in_session(session[:CLIENT_ID])
	        	redirect_to index_client_characteristic_path("clients", "work")
	        when 6718
	        	session[:HOUSEHOLD_ID] = work_task_object.reference_id
	        	session[:CLIENT_ID] = work_task_object.client_id
	        	redirect_to household_index_path
	        when 2140
	        	session[:CLIENT_ID] = work_task_object.client_id
	        	action_plan_detail = ActionPlanDetail.find(work_task_object.reference_id)
	        	action_plan = ActionPlan.find(action_plan_detail.action_plan_id)
	        	session[:PROGRAM_UNIT_ID] = action_plan.program_unit_id
	        	redirect_to action_plan_action_plan_detail_path(action_plan.id,action_plan_detail.id )
	        when 6469
	        	provider_invoice_object = ProviderInvoice.find(work_task_object.reference_id)
	        	session[:PROVIDER_ID] = provider_invoice_object.provider_id
	        	redirect_to provider_invoice_line_items_index_path(provider_invoice_object.id)
	        when 6470
	        	provider_invoice_object = ProviderInvoice.find(work_task_object.reference_id)
	        	session[:PROVIDER_ID] = provider_invoice_object.provider_id
	        	service_authorization_object = ServiceAuthorization.find(provider_invoice_object.service_authorization_id)
	        	redirect_to service_authorization_line_items_index_path(service_authorization_object.id)
        	when 2155
        		session[:CLIENT_ID] = work_task_object.client_id
	        	set_household_member_info_in_session(session[:CLIENT_ID])
	        	session[:APPLICATION_ID] = work_task_object.reference_id
	        	redirect_to navigator_validations_path
	        when 6766,6576
	        	session[:CLIENT_ID] = work_task_object.client_id
	        	session[:PROGRAM_UNIT_ID] = work_task_object.reference_id
	        	set_household_member_info_in_session(session[:CLIENT_ID])
	        	redirect_to action_plans_path
	        when 6386,6785
	        	session[:CLIENT_ID] = work_task_object.client_id
	            set_household_member_info_in_session(session[:CLIENT_ID])
	            session[:PROGRAM_UNIT_ID] = work_task_object.reference_id
	            program_wizards = ProgramWizard.where("program_unit_id = ? and submit_date is null",work_task_object.reference_id).order("id DESC")
	            if program_wizards.present?
					program_wizard = program_wizards.first
					eligibility_deterimine_results = EligibilityDetermineResult.get_results_list(program_wizard.run_id,program_wizard.month_sequence)
			        if eligibility_deterimine_results.where("program_unit_id is not null").count > 0
			        	redirect_to show_program_wizard_run_id_details_path(work_task_object.reference_id,program_wizard.id)
			        else
			        	redirect_to program_unit_data_validation_results_path(work_task_object.reference_id,0)
			        end
			    else
			    	redirect_to program_unit_data_validation_results_path(work_task_object.reference_id,0)
			    end

	    end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","work_on_task",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid work task."
		redirect_to_back
	end


	def work_task_search
		# fail
		@status_list = CodetableItem.item_list(185,"Work Status List")
		@local_office_list =  CodetableItem.item_list(2,"DWS Office List")
		@assigned_to_type_list =  CodetableItem.item_list(186,"Assignment To Type List")
	end

	def work_task_search_results
		# fail
		@user_or_office_name = nil
		@status_list = CodetableItem.item_list(185,"Work Status List")
		@local_office_list =  CodetableItem.item_list(2,"DWS Office List")
		@assigned_to_type_list =  CodetableItem.item_list(186,"Assignment To Type List")
		# process search functionality
		if  params[:status].present? && params[:assigned_to_type].present?
		# if params[:assigned_to_type].present?
			li_status = params[:status].to_i
			# Assigned to Type is selected
			if params[:assigned_to_type].to_i == 6342
				# fail
				# user
				@selected_assigned_to_type = "6342"
				if params[:assigned_to_user_id].present?
					@user_or_office_name = User.get_user_full_name(params[:assigned_to_user_id].to_i)
					# li_assigned_to_user_id =  params[:assigned_to_id].to_i
					l_records_per_page = SystemParam.get_pagination_records_per_page
					li_assigned_to_user_id =  params[:assigned_to_user_id]
					@work_task_search_results = WorkTask.get_user_tasks(li_assigned_to_user_id,li_status).page(params[:page]).per(l_records_per_page)
				else
					# flash.now[:alert] = "All Search criteria are required"
					@work_task = WorkTask.new
					@work_task.errors[:base] = "All search criteria are required."
					render :work_task_search
				end
			else
				# fail
				# local office
				@selected_assigned_to_type = "6343"
				if params[:assigned_to_office_id].present?
					@user_or_office_name = CodetableItem.get_short_description(params[:assigned_to_office_id].to_i)
					l_records_per_page = SystemParam.get_pagination_records_per_page
					li_assigned_local_office_id =  params[:assigned_to_office_id].to_i
					@work_task_search_results = WorkTask.get_local_office_tasks(li_assigned_local_office_id,li_status).page(params[:page]).per(l_records_per_page)
				else
					# flash.now[:alert]  = "All Search criteria are required"
					@work_task = WorkTask.new
					@work_task.errors[:base] = "All search criteria are required."
					render :work_task_search
				end
			end
		else
			# flash.now[:alert]  = "All Search criteria are required"
			@work_task = WorkTask.new
			@work_task.errors[:base] = "All search criteria are required."
			render :work_task_search
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid work task."
		redirect_to_back

	end

	def case_transfer_new

         @work_task = WorkTask.new
         @selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
         program_unit_id = @selected_program_unit.id
         # Rails.logger.debug("program_unit1 = #{program_unit_id}")
      rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","case_transfer_new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to assign task."
		redirect_to_back
	end

	def case_transfer_create
		if worktask_params[:assigned_to_id].present?
			@same_processing_location = false
			@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)

			# primary_beneficiary = ProgramUnitMember.get_primary_beneficiary(@selected_program_unit.id)
			primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.id, 6345)
			if worktask_params[:assigned_to_id].to_i == (@selected_program_unit.processing_location)
				 @same_processing_location = true
			end
			local_office = CodetableItem.get_short_description(worktask_params[:assigned_to_id].to_i)

			if primary_contact.blank?
				primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.client_application_id, 6587)
				# ApplicationMember.get_primary_applicant(@selected_program_unit.client_application_id)
			end
			@client = Client.find(primary_contact.client_id)
				li_event_type = nil
				begin
	            	ActiveRecord::Base.transaction do
						if @same_processing_location == true
						   li_event_type = 749
					       flash_msg = "Program Unit: #{@selected_program_unit.id} reassigned to local office: #{local_office}."
						else
							# Save the change in LOcation.
							@selected_program_unit.processing_location = worktask_params[:assigned_to_id].to_i
							@selected_program_unit.save!
							# Call case transfer to another local office event management.
							li_event_type = 748
							flash_msg = "Program Unit: #{@selected_program_unit.id} transferred to local office: #{local_office}."
						end

						# step1 : Populate common event management argument structure
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
			            common_action_argument_object.event_id = li_event_type
			            common_action_argument_object.program_unit_id = @selected_program_unit.id
		                common_action_argument_object.client_id = @client.id

			            # step2: call common method to process event.
			            ls_msg = EventManagementService.process_event(common_action_argument_object)
			            if ls_msg == "SUCCESS"
			            	flash[:notice] = flash_msg
			             	redirect_to my_program_units_path
			            else
			             	flash[:alert] = ls_msg
			             	@work_task = WorkTask.new
			             	render :case_transfer_new
			            end
		            end
	        rescue => err
	              error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","case_transfer_create",err,AuditModule.get_current_user.uid)
	              ls_msg = "Failed to process event - for more details refer to error ID: #{error_object.id}."
	              flash.now[:alert] = ls_msg
	              render :case_transfer_new
	        end
		else
			flash[:alert]  = "Transfered to local office is required."
			render :case_transfer_new
		end
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","case_transfer_create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to assign task."
		redirect_to_back
	end



	def my_program_units

		@current_user = AuditModule.get_current_user
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@my_program_units = ProgramUnit.get_logged_in_user_program_units(@current_user.uid).page(params[:page]).per(l_records_per_page)

		@my_program_units.each do |each_pgu|
			 # 6044- close,#6041- denied
		if program_unit_status = ProgramUnit.get_current_participation_status_value(each_pgu.id.to_i) != 6044 and each_pgu.disposition_status != 6041
			each_pgu.show_case_transfer_link = true
		else
			each_pgu.show_case_transfer_link = false
		end
	end
      @ls_logged_in_user = current_user.name

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","my_program_units",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when showing my program units."
		redirect_to_back
	end


	def my_applications

		@current_user = AuditModule.get_current_user
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@my_applications = ClientApplication.get_logged_in_user_updated_incomplete_applications(@current_user.uid).page(params[:page]).per(l_records_per_page)
		@ls_logged_in_user = current_user.name
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("WorkTasksController","my_applications",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when showing my applications."
		redirect_to_back
	end

	def selected_case
		client_application_id = nil
		url = nil
		params_id = params[:id].to_i
		params_type = params[:type].to_i
		case params[:type].to_i
		when 6587
			client_application_id = params_id
			url = application_summary_path(params_id)
		when 6345
			program_unit = ProgramUnit.find_by_id(params_id)
			client_application_id = program_unit.client_application_id
			session[:PROGRAM_UNIT_ID] = program_unit.id
			url = index_eligibility_determination_runs_path(params_id)
		end
		primary_contact = PrimaryContact.get_primary_contact(params_id, params_type)
		session[:CLIENT_ID] = primary_contact.client_id if primary_contact.present?
		session[:APPLICATION_ID] = client_application_id
 		client_application_object = ClientApplication.find_by_id(client_application_id)
 		session[:HOUSEHOLD_ID] = client_application_object.household_id
 		redirect_to url
	end




private

	def worktask_params
		params.require(:work_task).permit(:assigned_to_id, :task_category,:task_type ,:due_date,
  											:action_text ,:instructions , :urgency ,:notes, :status )




	end


end
