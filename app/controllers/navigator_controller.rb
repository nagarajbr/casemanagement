class NavigatorController < AttopAncestorController
	before_filter :set_client_application

	def eligible_program_units
		if session[:APPLICATION_ID].present?
			instances_for_eligible_program_units
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","eligible_program_units",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occured while populating eligible program units."
			redirect_to_back
	end

	def create
		if params[:service_programs].present?
			screening_input = {}
			screening_input[:service_programs] = params[:service_programs]
			screening_input[:program_unit_processing_location] = session[:PROGRAM_UNIT_PROCESSING_LOCATION]
			program_units = CaseCreatorService.determine_cases(session[:APPLICATION_ID], screening_input)
			primary_contact = PrimaryContact.get_primary_contact_for_application(session[:APPLICATION_ID])
			begin
				ActiveRecord::Base.transaction do
					@selected_application.application_status = 5942
					@selected_application.save!
					if program_units.present?
						program_units.each do |program_unit|
							common_action_argument_object = CommonEventManagementArgumentsStruct.new
						 	common_action_argument_object.event_id = 925
						 	# for queue movement
						 	common_action_argument_object.queue_reference_type = 6345 # program unit
						 	common_action_argument_object.queue_reference_id = program_unit.id
						 	# for work task creation
						 	common_action_argument_object.program_unit_id = program_unit.id
						 	common_action_argument_object.client_id = primary_contact.client_id
						 	common_action_argument_object.client_application_id = program_unit.client_application_id
						 	ls_msg = EventManagementService.process_event(common_action_argument_object)
						 	if ls_msg != "SUCCESS"
						 		break
					     	end
						end
					end

				end
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create",err,AuditModule.get_current_user.uid)
				ls_msg = "Failed to move selected programs units into ED queue - for more details refer to error ID: #{error_object.id}."
			end
			session[:APPLICATION_ID] = nil
			redirect_to alerts_path, notice: "Program units are created."
		else
			# fail
			instances_for_eligible_program_units
			flash[:notice] = "Please select atleast one program unit(s) to apply."
			render :eligible_program_units
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while creating eligible program units."
		redirect_to_back
	end

	def new_program_unit
		instances_for_new_program_unit
	end

	def create_new_program_unit
		@selected_application = ClientApplication.find(session[:APPLICATION_ID]) if session[:APPLICATION_ID].present?
		# fail
		if params[:service_program_id].blank?
			instances_for_new_program_unit
			@selected_application.errors[:base] << "Please select a service program."
			render :new_program_unit
		else
			begin
				ActiveRecord::Base.transaction do
					service_program_id = params[:service_program_id].to_i
					app_srvc_prgm_collection = ApplicationServiceProgram.where("client_application_id = ? and service_program_id = ?",@selected_application.id,service_program_id)
		            if app_srvc_prgm_collection.blank?
		            	app_srvc_prgm = ApplicationServiceProgram.new
		            	app_srvc_prgm.client_application_id = @selected_application.id
		            	app_srvc_prgm.service_program_id = service_program_id
		            	app_srvc_prgm.status = 4000  # Pending
		            	app_srvc_prgm.save!
		            end
		            program_unit = ProgramUnit.new
	            	program_unit.client_application_id = @selected_application.id
	            	program_unit.service_program_id = service_program_id
	            	program_unit.processing_location = @selected_application.application_received_office
	            	# program_unit.case_type = application_screening_object.determined_case_type
	            	program_unit.eligibility_worker_id = current_user.uid
	            	program_unit.save!
	            	# common_action_argument_object = CommonEventManagementArgumentsStruct.new
				 	# common_action_argument_object.event_id = 866
				 	# common_action_argument_object.queue_reference_type = 6587 # client application
				 	# common_action_argument_object.queue_reference_id = @selected_application.id
				 	# common_action_argument_object.client_application_id = @selected_application.id
				 	# ls_msg = EventManagementService.process_event(common_action_argument_object)

	            	# change the program unit state to complete
	            	program_unit.complete
	            	application_members = @selected_application.application_members
	            	application_members.each do |app_member|
		                program_unit_member = ProgramUnitMember.new
		                program_unit_member.program_unit_id = program_unit.id
		                program_unit_member.client_id = app_member.client_id
		                program_unit_member.member_of_application = "Y"
		                program_unit_member.member_status = 4468 # Active
		                application_primary_contact = PrimaryContact.get_primary_contact(@selected_application.id, 6587)
		                PrimaryContactService.save_primary_contact(program_unit.id, 6345, application_primary_contact.client_id) if application_primary_contact.present?
		                program_unit_member.save!
	            	end
	            	# fts = FamilyTypeService.new
					# family_type_struct = FamilyTypeStruct.new
					# family_type_struct = fts.determine_family_type_for_program_unit(program_unit.id)
					# program_unit.case_type = family_type_struct.case_type_integer
					# program_unit.save!
					ProgramUnitService.determine_case_type_for_program_unit_and_update(program_unit)
	                redirect_to edit_program_unit_wizard_initialize_path(program_unit.id)
				end
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create_new_program_unit transaction Management",err,AuditModule.get_current_user.uid)
				flash[:alert] = "Failed to create new program unit - for more details refer to error ID: #{error_object.id}."
				redirect_to new_program_unit_path
			end
		end
	end

	def navigator_validations
		fts = FamilyTypeService.new
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct = fts.determine_family_type(@selected_application.id)
		@family_type_struct.application_date = @selected_application.application_date
		@family_type_struct.household_id = session[:HOUSEHOLD_ID]
		@case_type = @family_type_struct.case_type
		appl_eligibilty_servc = ApplicationEligibilityService.new
		appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
		@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
		@called_from = "NAVIGATOR"
		session[:NAVIGATE_FROM] = nil
		if @app_elig_rslts.where("result = FALSE").count == 0
			redirect_to eligible_program_units_path
		else
			@member_steps = HouseholdMemberStepStatus.collection_of_steps_for_given_household_client(session[:HOUSEHOLD_ID],session[:CLIENT_ID])
			@client = Client.find(session[:CLIENT_ID])
		end
		# Show link to navigator page even when optional missing data elemnts are not fixed
		@can_show_next = @app_elig_rslts.where("result = FALSE and data_item_type not in (6035,6036,6754,6085)").count == 0
	end

	def reject_application
		instances_for_reject_application
		# if request.env['HTTP_REFERER'].include? "validations"
		# 	@back_button_url = navigator_validations_path
		# else
		# 	@back_button_url = eligible_program_units_path
		# end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","reject_application",err,AuditModule.get_current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while trying to deny an application."
		redirect_to_back
	end

	def create_application_rejection
		if params[:client_application][:application_disposition_reason].present?
			selected_application = ClientApplication.find(session[:APPLICATION_ID])
			selected_application.application_disposition_status = 6018 # "Rejected"
			selected_application.application_disposition_reason = params[:client_application][:application_disposition_reason].to_i

			notice_generation = NoticeGeneration.new
			notice_generation.notice_generated_date = Date.today
			notice_generation.action_type = 6018
			notice_generation.action_reason = params[:client_application][:application_disposition_reason].to_i
			notice_generation.date_to_print = Date.today
			notice_generation.notice_status = 6614 # "Pending"
			notice_generation.service_program_id = 1 # "Defaulting the service program id to TEA, for application denial"
			notice_generation.reference_type = 6587
			notice_generation.reference_id = selected_application.id

			# Complete the work task
			work_tasks = WorkTask.where("task_type = 2155 and beneficiary_type = 6587 and reference_id = ? and status = 6339",session[:APPLICATION_ID])
			if work_tasks.present?
	            work_task = work_tasks.first
	            work_task.complete_date = Date.today
	            work_task.status = 6341
	        end

	        work_queues = WorkQueue.where("state = 6558 and reference_type = 6587 and reference_id = ?",session[:APPLICATION_ID])

			begin
				ActiveRecord::Base.transaction do
					selected_application.save!
					notice_generation.save!
					work_task.save!
					work_queues.first.destroy! if work_queues.present?
				end
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create_application_rejection",err,AuditModule.get_current_user.uid)
				flash[:alert] = "Failed to complete denial process - for more details refer to error ID: #{error_object.id}."
				redirect_to reject_application_path
				return
			end
			redirect_to client_applications_path, notice: "Application rejected."
		else
			instances_for_reject_application
			@selected_application.errors[:base] << "Rejection reason is required."
			render :reject_application
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create_application_rejection",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while creating eligible program units."
		redirect_to_back
	end

	def deny_program_unit
		instances_for_deny_program_unit
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","deny_program_unit",err,AuditModule.get_current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while trying to deny an application."
		redirect_to_back
	end

	def create_program_unit_denial
		if params[:program_unit][:service_program_id].present? && params[:program_unit][:disposition_reason].present?
			program_unit = ProgramUnit.new
			program_unit.client_application_id = session[:APPLICATION_ID]
			program_unit.service_program_id = params[:program_unit][:service_program_id].to_i
			program_unit.disposition_status = 6763 # "Processed"
			program_unit.disposition_reason = params[:program_unit][:disposition_reason].to_i
			program_unit.disposition_date = Date.today
			program_unit.program_unit_status = 5942
			program_unit.case_manager_id = AuditModule.get_current_user.uid
			program_unit.disposed_by = AuditModule.get_current_user.uid

			program_unit_member = ProgramUnitMember.new
			program_unit_member.client_id = session[:CLIENT_ID]
			program_unit_member.member_status = 4468 # "Active"

			program_unit_participation = ProgramUnitParticipation.new
			program_unit_participation.participation_status = 6041 # "Denial"
			program_unit_participation.reason = params[:program_unit][:disposition_reason].to_i
			program_unit_participation.status_date = Date.today

			notice_generation = NoticeGeneration.new
			notice_generation.notice_generated_date = Date.today
			notice_generation.action_type = 6099 # "Deny"
			notice_generation.action_reason = params[:program_unit][:disposition_reason].to_i
			notice_generation.date_to_print = Date.today
			notice_generation.notice_status = 6614 # "Pending"
			notice_generation.service_program_id = params[:program_unit][:service_program_id].to_i
			notice_generation.reference_type = 6345

			work_queues = WorkQueue.where("state = 6558 and reference_type = 6587 and reference_id = ?",session[:APPLICATION_ID])

			application_primary_contact = PrimaryContact.get_primary_contact_for_application(session[:APPLICATION_ID])
			primary_client_id = application_primary_contact.client_id

			# Complete the work task
			work_tasks = WorkTask.where("task_type = 2155 and beneficiary_type = 6587 and reference_id = ? and status = 6339",session[:APPLICATION_ID])
			if work_tasks.present?
	            work_task = work_tasks.first
	            work_task.complete_date = Date.today
	            work_task.status = 6341
	        end

			begin
				ActiveRecord::Base.transaction do
					program_unit.save!
					program_unit_member.program_unit_id = program_unit.id
					program_unit_member.save!
					PrimaryContactService.save_primary_contact(program_unit.id, 6345, primary_client_id)
					program_unit_participation.program_unit_id = program_unit.id
					program_unit_participation.save!
					notice_generation.reference_id = program_unit.id
					notice_generation.save!
					work_task.save! if work_tasks.present?
					work_queues.first.destroy! if work_queues.present?
				end
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create_program_unit_denial",err,AuditModule.get_current_user.uid)
				flash[:alert] = "Failed to complete denial process - for more details refer to error ID: #{error_object.id}."
				redirect_to deny_program_unit_path
				return
			end
			redirect_to alerts_path, notice: "Denial created."
		else
			instances_for_deny_program_unit
			if params[:program_unit][:service_program_id].blank?
				@program_unit.errors[:base] << "Service program is required."
			else
				@program_unit.service_program_id = params[:program_unit][:service_program_id]
			end
			if params[:program_unit][:disposition_reason].blank?
				@program_unit.errors[:base] << "Denial reason is required."
			else
				@program_unit.disposition_reason = params[:program_unit][:disposition_reason]
			end
			render :deny_program_unit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("NavigatorController","create_program_unit_denial",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while creating program unit denial."
		redirect_to_back
	end

	private

		def set_client_application
			@selected_application = ClientApplication.find(session[:APPLICATION_ID]) if session[:APPLICATION_ID].present?
		end

		def instances_for_eligible_program_units
			screening_only = true
			@family_comp = CaseCreatorService.determine_cases(session[:APPLICATION_ID], screening_only)
			@selected_application = ClientApplication.find(session[:APPLICATION_ID].to_i)
			@service_programs = ServiceProgram.get_service_programs_for_category_id(6015)
			@screeningineligiblecode = screeningineligiblecode = ScreeningIneligibleCode.where("application_id = ?",session[:APPLICATION_ID].to_i)
		end

		def instances_for_new_program_unit
			srvc_pgms = [1,3,4]
			@service_programs = ServiceProgram.where("id in (?)",srvc_pgms).order("id")
			@selected_application = ClientApplication.find(session[:APPLICATION_ID]) if session[:APPLICATION_ID].present?
		end

		def instances_for_reject_application
			@selected_application = ClientApplication.find(session[:APPLICATION_ID]) if session[:APPLICATION_ID].present?
			@action_reasons = CodetableItem.get_code_table_values_by_system_params("TEA_DENIAL_REASONS")
			@action_reasons += CodetableItem.get_code_table_values_by_system_params("WORK_PAYS_DENIAL_REASONS")
		end

		def instances_for_deny_program_unit
			@program_unit = ProgramUnit.new
			instances_for_new_program_unit
			@action_reasons = CodetableItem.get_code_table_values_by_system_params("TEA_DENIAL_REASONS")
			@action_reasons += CodetableItem.get_code_table_values_by_system_params("WORK_PAYS_DENIAL_REASONS")
		end
end
