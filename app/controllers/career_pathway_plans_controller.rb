class CareerPathwayPlansController < AttopAncestorController
	def index
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		client_assessment_collection = ClientAssessment.get_client_assessments(session[:CLIENT_ID].to_i)
		if client_assessment_collection.present?
			 @assessment_id = client_assessment_collection.first.id
			 @approved_career_pathway_plans = CareerPathwayPlan.get_approved_cpp_plan_list_for_selected_client(@client.id)
			 @not_approved_career_pathway_plans = CareerPathwayPlan.get_not_approved_cpp_plan_list_for_selected_client(@client.id)
		else
			# Assessment not found
			 @assessment_id = nil
		end
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6746,nil)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when attempted to access career plan."
			redirect_to_back
	end

	def show
		# APPROVED CPP PLANS CALLS THIS ACTION
		# ALL RECORDS NEEDS TO SHOWN FROM SNAPSHOT
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
		@assessment_id = ClientAssessment.get_assessment_id(session[:CLIENT_ID])
		l_career_pathway_plan_id = params[:cpp_id].to_i
		@career_pathway_plan_id = l_career_pathway_plan_id
		@career_pathway_plan = CareerPathwayPlan.find(l_career_pathway_plan_id)
		@assessment_barriers_from_snap_shot = AssessmentBarrierCppSnapshot.get_assessment_barriers_from_snapshot(l_career_pathway_plan_id)
		@assessed_sections_with_barriers_from_snapshot = AssessmentSection.get_assessed_sections_with_barriers_from_snapshot(l_career_pathway_plan_id)
		@approved_employment_plan_details_from_snap_shot = ActionPlanDetailCppSnapshot.get_open_action_plan_details_from_snapshot(l_career_pathway_plan_id)


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when attempted to access show career plan."
		redirect_to_back
	end

	def show_pending_cpp
		# Not approved cpp plans
		@can_show_approve_reject_buttons = false
		@can_edit = false
		@career_pathway_plan = CareerPathwayPlan.find(params[:cpp_id])
		populate_current_cpp_instance_variables
		action_plan_partial_instance_variables
		if @career_pathway_plan.state == 6373 #state is requested
				@can_show_approve_reject_buttons = true
		end

		# check if somebody volunteered to work on approving the CPP.
		program_task_owners_collection = ProgramUnitTaskOwner.where("program_unit_id = ?
				                                          and ownership_type = 6619
				                                          and ownership_user_id is not null",@selected_program_unit.id)


		@ls_security_message = " "
		if program_task_owners_collection.present?
		   program_task_owner_object = program_task_owners_collection.first
		   if program_task_owner_object.ownership_user_id == current_user.uid
		   else
		   	 ls_user_name = User.get_user_full_name(program_task_owner_object.ownership_user_id)
		   	 @ls_security_message =  "Approve career plan task is assigned to User: #{ls_user_name}. he/she will review and approve this career plan."
		   end
		else
			queue_state_object = WorkQueue.get_the_state_of_the_reference_id(6345,@selected_program_unit.id)
			if queue_state_object.present? && queue_state_object == 6637
				@ls_security_message = " Requested career plan is in queue:'Ready for Career Plan Approval',not assigned to any user.Users subscribed to that queue will be able to approve this career plan."
			end

		end

		# show warning messages - if cpp does not allign with core component hours
		@warnings = show_core_component_warning_messages(@selected_program_unit.id,@client.id)

	rescue => err
		 	error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","show_pending_cpp",err,current_user.uid)
		 	flash[:alert] = "Error ID: #{error_object.id} - Error when attempted to access show career plan."
		 	redirect_to_back
	end

	def manage_cpp
		# similar to Edit/new action
		populate_current_cpp_instance_variables
		# ACTION PLANS PARTIAL RELATED INSTANCE VARIABLES.
		action_plan_partial_instance_variables
		# show warning messages - if cpp does not allign with core component hours
		@warnings = show_core_component_warning_messages(@selected_program_unit.id,@client.id)
		# we have to set this to zero to open records from main table instead of snapshot tables.
		# Dont delete this assignment
		@career_pathway_plan_id = 0
		if params[:cpp_id].present?
			# EDIT
			@cpp_object = CareerPathwayPlan.find(params[:cpp_id])
			@allow_cpp = true
			@service_plan_found = "Y"
			@communication_type = CodetableItem.item_list(177,"Communication Type")
			@case_worker_list = User.all
			@supervisor_list = User.all
			@cpp_object.core_hours = CareerPathwayPlan.get_core_hours_from_activities(@client.id)
			@cpp_object.non_core_hours = CareerPathwayPlan.get_non_core_hours_from_activities(@client.id)
		else
			# NEW
			# can cpp be created?
			ls_message = CareerPathwayPlan.can_cpp_be_created?(@client.id)
			if ls_message == "YES"
				@service_plan_found = "Y"
				# check if there is pending CPP not signed by client
				@allow_cpp = CareerPathwayPlan.no_cpp_plan_with_approved_status_found(@client.id)
				if @allow_cpp == true
					@cpp_object = CareerPathwayPlan.new
					@communication_type = CodetableItem.item_list(177,"Communication Type")
					@case_worker_list = User.all
					@supervisor_list = User.all
					@cpp_object.core_hours = CareerPathwayPlan.get_core_hours_from_activities(@client.id)
					@cpp_object.non_core_hours = CareerPathwayPlan.get_non_core_hours_from_activities(@client.id)
				else
					@pending_career_pathway_plans = CareerPathwayPlan.get_not_approved_cpp_plan_list_for_selected_client(@client.id)
				end
			else
				@service_plan_found = "N"
			end
		end
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","manage_cpp",err,current_user.id)
			flash[:alert] = "Error ID: #{error_object.id} - Error when attempted to access new career plan."
			redirect_to_back
	end

	def save_cpp
		# similar to Create/Update
		# View related Instance variables
		populate_current_cpp_instance_variables
		@communication_type = CodetableItem.item_list(177,"Communication Type")
		@case_worker_list = User.all
		@supervisor_list = User.all

		lb_saved = true
		ls_flash_message = " "


		l_params = cpp_params
		@cpp_object = set_data_to_cpp_table(l_params)
		@cpp_object.client_signature = @client.id
		@cpp_object.client_signed_date = l_params["client_signed_date"]
		@cpp_object.program_unit_id = @selected_program_unit.id
		if @cpp_object.valid?
			if l_params[:id].present?
				# edit mode
				if @cpp_object.state == 6167
					# rejected CPP
					begin
		      			ActiveRecord::Base.transaction do
		      				@cpp_object.reason = nil
		      				rejected_supervisor_user_id = @cpp_object.supervisor_signature
	      					@cpp_object.supervisor_signature = nil
	      					@cpp_object.supervisor_signed_date = nil
	      					@cpp_object.state = 6167
	      					lb_saved = @cpp_object.re_request
							if lb_saved == true
							else
								ls_flash_message = @cpp_object.errors.full_messages.last
							end
							# Do event processing only if cpp save is successful
							if lb_saved == true
			      				# do the actions associated with this event
			      				 # step2: call common method to process event.
						        	# Rails.logger.debug("ABC-common_action_argument_object = #{common_action_argument_object.inspect}.")
						        	# step1 : Populate common event management argument structure
									common_action_argument_object = CommonEventManagementArgumentsStruct.new
									common_action_argument_object.event_id = 838 # "Complete CPP"
									# work task related attributes
									common_action_argument_object.reason = "REJECT_TO_REQUEST"
									common_action_argument_object.ownership_user_id =  rejected_supervisor_user_id
									common_action_argument_object.cpp_id = @cpp_object.id
									common_action_argument_object.client_id = session[:CLIENT_ID]
									common_action_argument_object.program_unit_id = @cpp_object.program_unit_id
									#queue related attributes
									common_action_argument_object.queue_reference_type = 6345 # Program Unit
									common_action_argument_object.queue_reference_id = @cpp_object.program_unit_id
							        ls_flash_message = EventManagementService.process_event(common_action_argument_object)
									if ls_flash_message == "SUCCESS"
										lb_saved = true
									else
										lb_saved = false
									end
							end
		      			end
		      		rescue => err
				   		 error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","save_cpp",err,AuditModule.get_current_user.uid)
				   		 lb_saved = false
				   		 ls_flash_message = "Failed to complete career plan - for more details refer to Error ID: #{error_object.id}."
			    	end
				else
					# requested CPP
					@cpp_object.state = 6165
					@cpp_object.save
					lb_saved = @cpp_object.request
				end

				if lb_saved
					ls_flash_message = "Career plan completed successfully."
				else
					ls_flash_message = @cpp_object.errors.full_messages.last
				end

				if lb_saved == true
					flash[:notice] = ls_flash_message
				else
					flash[:alert] = ls_flash_message
				end
			else
				# NEW
					begin
		      			ActiveRecord::Base.transaction do
		      					@cpp_object.state = 6165
		      					@cpp_object.save!
		      					# status set to complete.
		      					# change the status to requested also.
		      					lb_saved = @cpp_object.request
								if lb_saved
									ls_flash_message = "Career plan completed successfully."
								else
									ls_flash_message = @cpp_object.errors.full_messages.last
								end
		      				# Do event processing only if cpp save is successful
		      				if lb_saved == true
			      				# do the actions associated with this event
			      				 # step2: call common method to process event.
						        	# Rails.logger.debug("ABC-common_action_argument_object = #{common_action_argument_object.inspect}.")
						        	# step1 : Populate common event management argument structure
									common_action_argument_object = CommonEventManagementArgumentsStruct.new
									common_action_argument_object.event_id = 838 # "Complete CPP"
									# work task related attributes
									common_action_argument_object.cpp_id = @cpp_object.id
									common_action_argument_object.client_id = session[:CLIENT_ID]
									common_action_argument_object.program_unit_id = @cpp_object.program_unit_id
									#queue related attributes
									common_action_argument_object.queue_reference_type = 6345 # Program Unit
									common_action_argument_object.queue_reference_id = @cpp_object.program_unit_id
							        ls_flash_message = EventManagementService.process_event(common_action_argument_object)
									if ls_flash_message == "SUCCESS"
										lb_saved = true
										ls_flash_message = "Career plan completed successfully."
									else
										lb_saved = false
									end
							end
		      			end
		      	 	 rescue => err
				   		 error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","save_cpp",err,AuditModule.get_current_user.uid)
				   		 lb_saved = false
				   		 ls_flash_message = "Failed to complete career plan - for more details refer to Error ID: #{error_object.id}."
			    	end
					if lb_saved
						flash[:notice] = ls_flash_message
					else
						flash[:alert] = ls_flash_message
					end

			end
			redirect_to index_cpp_path(@assessment_id)
		else
			render :manage_cpp
		end
     rescue => err
			 error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","save_cpp",err,current_user.uid)
			 flash[:alert] = "Error ID: #{error_object.id} - Error when attempted to saving career plan."
			 # redirect_to_back
			 redirect_to index_cpp_path(@assessment_id)
	end

	# def request_for_approval

	# 	lb_saved = true
	# 	ls_flash_message = ""
	# 	li_client_id = session[:CLIENT_ID].to_i
	# 	li_cpp_id = params[:cpp_id]
	# 	assessment_id = ClientAssessment.get_assessment_id(li_client_id)
	# 	cpp_object = CareerPathwayPlan.find(li_cpp_id)
	# 	ls_local_office = ProgramUnit.get_processing_local_office_name(cpp_object.program_unit_id)
	# 	begin
 #      		ActiveRecord::Base.transaction do
 #      			cpp_object.reason = nil
 #      			cpp_object.supervisor_signature = nil
 #      			# step1 : Populate common event management argument structure
	# 			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	# 	        common_action_argument_object.event_id = 291 # Request for Approval of CPP
	# 	        common_action_argument_object.cpp_id = li_cpp_id
	# 	        common_action_argument_object.client_id = li_client_id
	# 	        # common_action_argument_object.program_unit_id = cpp_object.program_unit_id
	# 	        common_action_argument_object.queue_reference_type = 6465 # CPP
	#     		common_action_argument_object.queue_reference_id = cpp_object.id
	# 	        # step2: call common method to process event.
	# 	        ls_flash_message = EventManagementService.process_event(common_action_argument_object)

	# 			if ls_flash_message == "SUCCESS"
	# 				lb_saved = cpp_object.request
	# 				if lb_saved
	# 					ls_flash_message = "Request for approval of CPP is successful."
	# 				else
	# 					ls_flash_message = cpp_object.errors.full_messages.last
	# 				end
	# 			else
	# 				lb_saved = false
	# 			end
	# 		end
	# 	  	rescue => err
	# 	  		error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","request_for_approval",err,AuditModule.get_current_user.uid)
	# 	  		lb_saved = false
	# 	  		ls_flash_message = "Failed to approve CPP - for more details refer to Error ID: #{error_object.id}."
 #        end
 #        if lb_saved
	# 		flash[:notice] = ls_flash_message
	# 		redirect_to index_cpp_path(li_cpp_id)
 #        else
 #        	flash[:alert] = ls_flash_message
	# 		redirect_to show_pending_cpp_path(li_cpp_id)
 #        end
	# 	rescue => err
	# 		error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","request_for_approval",err,current_user.uid)
	# 		flash[:alert] = "Error ID: #{error_object.id} - Error when requesting CPP for approval."
	# 		redirect_to_back
	# end

	def edit_cpp_reject
		@career_pathway_plan = CareerPathwayPlan.find(params[:cpp_id])
		populate_current_cpp_instance_variables
		# ACTION PLANS PARTIAL RELATED INSTANCE VARIABLES.
		action_plan_partial_instance_variables
		# show warning messages - if cpp does not allign with core component hours
		@warnings = show_core_component_warning_messages(@selected_program_unit.id,@client.id)
		# assessment_id = ClientAssessment.get_assessment_id(session[:CLIENT_ID])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","edit_cpp_reject",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when rejecting the career plan."
		redirect_to_back
	end

	def update_cpp_reject
		lb_saved = true
		ls_flash_message = ""
		@career_pathway_plan = CareerPathwayPlan.find(params[:cpp_id])

		populate_current_cpp_instance_variables
		# ACTION PLANS PARTIAL RELATED INSTANCE VARIABLES.
		action_plan_partial_instance_variables
		# show warning messages - if cpp does not allign with core component hours
		@warnings = show_core_component_warning_messages(@selected_program_unit.id,@client.id)


		l_params = cpp_reject_params
		@career_pathway_plan.reason = l_params[:reason]
		# @career_pathway_plan.rejected_by = current_user.uid
		# @career_pathway_plan.rejected_date = DateTime.now
		li_cpp_state = @career_pathway_plan.state
		@career_pathway_plan.state = 6167 # Manually setting the state to reject to validate rejection reason is mandatory.
		if @career_pathway_plan.valid?
			begin
				ActiveRecord::Base.transaction do
					@career_pathway_plan.state = li_cpp_state
					# step1 : Populate common event management argument structure
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.event_id = 741 # "Request to Approve CPP is Rejected"
			        common_action_argument_object.cpp_id = @career_pathway_plan.id
			        common_action_argument_object.client_id = session[:CLIENT_ID]
			        common_action_argument_object.program_unit_id = @career_pathway_plan.program_unit_id
			        common_action_argument_object.reason = @career_pathway_plan.reason
			        # queue related setting
			        common_action_argument_object.queue_reference_type = 6345 # program unit
		    		common_action_argument_object.queue_reference_id = @career_pathway_plan.program_unit_id
			        # step2: call common method to process event.
			        #

					# if ls_flash_message == "SUCCESS"
						cpp_records_to_reject_collection = ProgramUnit.get_completed_cpp_for_adult_program_unit_members(@career_pathway_plan.program_unit_id)
						if cpp_records_to_reject_collection.present?
							cpp_records_to_reject_collection.each do |each_cpp_object|
								each_cpp_object.reason = l_params[:reason]
								each_cpp_object.supervisor_signature = AuditModule.get_current_user.uid
								each_cpp_object.supervisor_signed_date = Date.today

								each_cpp_object.state = 6373

								lb_saved = each_cpp_object.reject
								if lb_saved == false
									ls_flash_message = each_cpp_object.errors.full_messages.last
									break
								end
							end
						end

						if lb_saved == true
							ls_flash_message = EventManagementService.process_event(common_action_argument_object)
							if ls_flash_message == "SUCCESS"
								lb_saved = true
							else
								lb_saved = false
							end
						end
					# else
					# 	lb_saved = false
					# end
				end
		  	rescue => err
		  		error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","update_cpp_reject",err,AuditModule.get_current_user.uid)
		  		lb_saved = false
		  		ls_flash_message = "Failed to reject career plan - for more details refer to Error ID: #{error_object.id}."
	        end

	        if lb_saved
	        	flash[:notice] = "career plan rejected."
				redirect_to index_cpp_path(@career_pathway_plan.id)
	        else
	        	flash[:alert] = ls_flash_message
				redirect_to show_pending_cpp_path(@career_pathway_plan.id)
	        end
	    else
	    	populate_current_cpp_instance_variables
	    	render :edit_cpp_reject
	    end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","update_cpp_reject",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when rejecting career plan."
		redirect_to_back
	end

	def approve_cpp
		lb_saved = true
		ls_flash_message = ""
		begin
      		ActiveRecord::Base.transaction do
				client = Client.find(session[:CLIENT_ID])
				l_assessment_id = ClientAssessment.get_assessment_id(session[:CLIENT_ID])
				@career_pathway_plan = CareerPathwayPlan.find(params[:cpp_id])
				message = CareerPathwayPlan.create_client_signed_cpp_snapshot_in_one_transaction(client.id,l_assessment_id,@career_pathway_plan)
				if message == "SUCCESS"
					@career_pathway_plan.reason = nil
					# step1 : Populate common event management argument structure
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.event_id = 740 # "Request to Approve CPP is Approved"
			        common_action_argument_object.cpp_id = @career_pathway_plan.id
			        common_action_argument_object.client_id = session[:CLIENT_ID]
			        common_action_argument_object.program_unit_id = @career_pathway_plan.program_unit_id
			        # queue related settings
			        common_action_argument_object.queue_reference_type = 6345 # program unut
		    		common_action_argument_object.queue_reference_id =  @career_pathway_plan.program_unit_id

					begin
						@career_pathway_plan.supervisor_signature = AuditModule.get_current_user.uid
						@career_pathway_plan.supervisor_signed_date = Date.today
		                lb_saved = @career_pathway_plan.approve
		                if lb_saved == false
		                	 raise "error"
		                end
		            rescue => err
		                 error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","career_pathway_plan.approve",err,AuditModule.get_current_user.uid)
		            end
					if lb_saved
						# step2: call common method to process event.
		       			ls_flash_message = EventManagementService.process_event(common_action_argument_object)
		       			if ls_flash_message == "SUCCESS"
		       				ls_flash_message = "career plan is approved."
		       			else
		       				lb_saved = false
		       			end
					else
						ls_flash_message = "Failed to approve career plan."
					end

				else
					ls_flash_message = message
					lb_saved = false
				end
			end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","approve_cpp",err,AuditModule.get_current_user.uid)
			lb_saved = false
			ls_flash_message = "Failed to approve career plan - for more details refer to Error ID: #{error_object.id}."
	    end
	    if lb_saved
	    	flash[:notice] = ls_flash_message
			redirect_to index_cpp_path(@career_pathway_plan.id)
	    else
	    	flash[:alert] = ls_flash_message
			redirect_to show_pending_cpp_path(@career_pathway_plan.id)
	    end

	rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("CareerPathwayPlansController","approve_cpp",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} -  Error when approving career plan."
	 	redirect_to_back
	end

	def create_comments_for_career_pathway_plan
		if params[:notes].present?
			NotesService.save_notes(6150,session[:CLIENT_ID],6746,nil,params[:notes])
			redirect_to index_cpp_path
		else
			flash[:alert] = "Comments are required."
			redirect_to index_cpp_path
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ActionPlansController","create_comments_for_employment_plan",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when adding comments to employment plan."
			redirect_to_back
	end


	private

		def set_data_to_cpp_table(arg_hash)
			l_assessment_id = ClientAssessment.get_assessment_id(session[:CLIENT_ID])
			if arg_hash[:id].present?
				@cpp_object = CareerPathwayPlan.find(arg_hash[:id].to_i)
			else
				@cpp_object = CareerPathwayPlan.new
				@cpp_object.state = 6165
			end
			@cpp_object.client_assessment_id = l_assessment_id
			@cpp_object.case_worker_signature = current_user.uid
			@cpp_object.case_worker_signed_date = arg_hash["case_worker_signed_date"]
			@cpp_object.update_communication_type = arg_hash["update_communication_type"]

			# hours -
			@cpp_object.core_hours = arg_hash["core_hours"]
			@cpp_object.non_core_hours = arg_hash["non_core_hours"]


			return @cpp_object
		end

		def cpp_params
			params.require(:career_pathway_plan).permit(:client_signed_date, :case_worker_signed_date,:update_communication_type,:core_hours,:non_core_hours, :id)
  	 	end

  	 	def cpp_reject_params
  	 		params.require(:career_pathway_plan).permit(:reason)
  	 	end

  	 	def populate_current_cpp_instance_variables
  	 		@client = Client.find(session[:CLIENT_ID])
			@selected_program_unit = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
			@assessment_id = ClientAssessment.get_assessment_id(session[:CLIENT_ID])
			@assessed_sections_with_barriers = AssessmentSection.get_assessed_sections_with_barriers(@assessment_id)
			@assessment_barriers = AssessmentBarrier.get_assessment_barriers(@assessment_id)
			@open_employment_plan_details = CareerPathwayPlan.get_open_action_plan_details(@selected_program_unit.id,@client.id)
			@service_program_id = @selected_program_unit.service_program_id
			@case_type_id =  @selected_program_unit.case_type
			@planned_client_activity_hours_collection = CareerPathwayPlan.planned_work_participation_hours_for_program_unit(@selected_program_unit.id)
  	 	end


  	 	def action_plan_partial_instance_variables
  	 		l_records_per_page = SystemParam.get_pagination_records_per_page
			# @action_plan_details = @action_plan.action_plan_details.where("entity_type != 6294").page(params[:page]).per(l_records_per_page)
			@scheduled_activities = ActionPlanDetail.get_all_open_activities_for_program_unit(session[:PROGRAM_UNIT_ID])
			@completed_activities = ActionPlanDetail.get_all_completed_activities_for_program_unit(session[:PROGRAM_UNIT_ID])
			@scheduled_activities = @scheduled_activities.page(params[:page]).per(l_records_per_page) if @scheduled_activities.present?
			@completed_activities = @completed_activities.page(params[:page]).per(l_records_per_page) if @completed_activities.present?
			@action_plan = ActionPlan.get_open_action_plan(session[:PROGRAM_UNIT_ID], session[:CLIENT_ID])
			instances = ActionPlanService.get_instances_for_active_plan_summary(session[:PROGRAM_UNIT_ID], @action_plan)
			@employment_goal = instances[:employment_goal]
			@work_participation = instances[:work_participation]
  	 	end

  	 	def show_core_component_warning_messages(arg_program_unit_id,arg_client_id)
  	 		# find open action plan details for this client.
  	 		final_warnings = []
  	 		open_employment_plan_details = CareerPathwayPlan.get_open_employment_plan_details(arg_program_unit_id,arg_client_id)
  	 		if open_employment_plan_details.present?
  	 			open_employment_plan_details.each do |each_action_plan_detail|
  	 				each_action_plan_detail.program_unit_id = arg_program_unit_id
  	 				if each_action_plan_detail.component_type.present?
  	 					# set duration virtual attribute.
  	 					li_duration = each_action_plan_detail.get_duration
  	 					each_action_plan_detail.duration = li_duration
  	 					# set days_of_week virtual attribute.


	  	 				case each_action_plan_detail.component_type
				            when 6238 # "Job Search and Job Readiness"
				            	schedule = Schedule.get_schedule_info_from_action_plan_detail_id(each_action_plan_detail.id)
								each_action_plan_detail.days_of_week = schedule.day_of_week
				                warnings = each_action_plan_detail.perform_validations_for_component_type_job_serach_and_job_readiness
	                            if warnings.present?
	                            	warnings.each do |each_warning|
	                            		final_warnings << each_warning
	                            	end
	                            end
				            when 6239,6241,6242,6243
				                            # 6239 On the Job Training
				                            # 6241 Work Experience
				                            # 6242 Subsidized Private Employment
				                            # 6243 Subsidized Public Employment
				                            warnings = each_action_plan_detail.perform_validations_for_component_type
				                            if warnings.present?
				                            	warnings.each do |each_warning|
				                            		final_warnings << each_warning
				                            	end
				                            end

				            when 6240 # "Career and Technical Education"
				                           warnings = each_action_plan_detail.perform_validations_for_career_and_technical_education
				                            if warnings.present?
				                            	warnings.each do |each_warning|
				                            		final_warnings << each_warning
				                            	end
				                            end
			            end
			        end  # end of   each_action_plan_detail.component_type.present?
  	 			end # end of open_employment_plan_details.each
  	 		end
  	 		return final_warnings
  	 	end
end