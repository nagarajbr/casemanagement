class ProgramUnitActionsController < AttopAncestorController
	# Author: Manoj Patil
	# Date: 11/10/2014
	# Description: To manage - Program Unit actions - DEny,Close,Reinstate.
	def show
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_wizards = @selected_program_unit.program_wizards.order("id DESC")
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when showing action details."
		redirect_to_back

	end



	def edit
		populate_edit_attributes("edit")
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -Error occured when editing action."
		redirect_to_back
	end

	def update
		# similar to UPDATE REST action.
		@client = Client.find(session[:CLIENT_ID])
		# similar to EDIT REST action.
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		program_participation_list = ProgramUnitParticipation.get_participation_status(@selected_program_unit.id)
		if program_participation_list.present?
			status_date = program_participation_list.first.status_date
		end
		# Rails.logger.debug("program_participation_list = #{program_participation_list.inspect}")
		# Rails.logger.debug("status_date = #{status_date.inspect}")
		# fail

  		@pgu_action = PguAction.find(session[:NEW_PGU_ACTION_ID].to_i)
      	#  first step is assigned to current step -when session[:PROGRAM_WIZARD_STEP] is null
      	@pgu_action.current_step = session[:PGU_ACTION_STEP]

      	# Manage steps -start
      	if params[:back_button].present?
      		 @pgu_action.previous_step
      	elsif @pgu_action.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @pgu_action.next_step
        end
       session[:PGU_ACTION_STEP] = @pgu_action.current_step
       # Manage steps -end

        # what step to process?
		if @pgu_action.get_process_object == "pgu_action_first" && params[:next_button].present?
			l_params = params[:pgu_action]
			# if params[:pgu_action].present?
			if l_params[:pgu_action].present?
				# l_params = params[:pgu_action]
				session[:SELECTED_PGU_ACTION] = l_params[:pgu_action]
				redirect_to edit_program_unit_action_path(@selected_program_unit.id)
			else
				@pgu_action.previous_step
			 	session[:PGU_ACTION_STEP] = @pgu_action.current_step
			 	# @pgu_action.errors[:base] = "Program Action can't be blank"
			 	populate_edit_attributes("update")
			 	@pgu_action.errors[:pgu_action] = "is required."
			 	render :edit
			end


		elsif @pgu_action.current_step == "pgu_action_last"

			l_params = params[:pgu_action]
			if  valid_action
					case session[:SELECTED_PGU_ACTION]
						when "6100" # close
							# @action_reasons = CodetableItem.item_list(73,"Close Reasons")
                                action_date = DateService.program_unit_close_date_validation(status_date,l_params[:pgu_action_date].to_date)
					            if action_date == true
								    msg = save_close_action(l_params,@selected_program_unit.id)
								else
								 	populate_edit_attributes("update")
								 	@pgu_action.errors[:pgu_action_date] = "#{action_date}"
								end
						when "6099" # Deny
							msg = save_deny_action(l_params,@selected_program_unit.id)
							# if msg == "SUCCESS"
							# 	application = ClientApplication.find(@selected_program_unit.client_application_id)
							# 	application.application_disposition_reason = l_params[:pgu_action_reason]
							# 	application.application_disposition_status = 6041 # Denied
							# 	application.application_status = 5942 # complete.
							# 	application.disposition_date = Date.today
							# 	application.save
							# end
							# @action_reasons = CodetableItem.item_list(66,"Deny Reasons")
						when "6101" # Reopen or Reinstate

							msg = save_reinstate_action(l_params,@selected_program_unit.id)
							# @action_reasons = CodetableItem.item_list(66,"Deny Reasons")
					end
					if msg == "SUCCESS"
						flash[:notice] = "Program action saved."
						redirect_to show_program_unit_action_path(@selected_program_unit.id)
					elsif msg == nil
						render :edit
					else
						flash[:notice] = msg
						render :edit
					end

			else
			 	populate_edit_attributes("update")
			 	@pgu_action.pgu_action_reason = l_params[:pgu_action_reason]
			 	if session[:SELECTED_PGU_ACTION].to_i == 6100
                   @pgu_action.pgu_action_date = l_params[:pgu_action_date].to_date
			 	   @pgu_action.errors[:pgu_action_date] = "is required." if l_params[:pgu_action_date].blank?
			 	end
				@pgu_action.errors[:pgu_action_reason] = "is required." if l_params[:pgu_action_reason].blank?

				render :edit
			end


		else

			redirect_to edit_program_unit_action_path(@selected_program_unit.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when saving action."
		redirect_to_back
	end



	def cancel_pgu_action_wizard
		# Delete program_wizard & Program_benefit_meber if No Eligibility Determination step complete
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		PguAction.where("program_unit_id = ?",@selected_program_unit.id).destroy_all
		# redirect_to program_wizards_path
		redirect_to show_program_unit_action_path(@selected_program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","cancel_pgu_action_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when cancelling action."
		redirect_to_back
	end

	def program_unit_action_wizard_initialize
		# Rails.logger.debug("params[:program_unit_id].to_i = #{params[:program_unit_id].to_i}")
		# fail
		session[:PGU_ACTION_STEP] = session[:NEW_PGU_ACTION_ID]  =  nil
		# create new wizard ID.
		pgu_action_object = PguAction.new
		pgu_action_object.program_unit_id = params[:program_unit_id].to_i
		pgu_action_object.save
		session[:NEW_PGU_ACTION_ID] = pgu_action_object.id
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		redirect_to edit_program_unit_action_path(@selected_program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","program_unit_action_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when initializing program unit action wizard."
		redirect_to_back
	end


  private

  	def valid_action
		msg = false
		l_params = params[:pgu_action]
		if session[:SELECTED_PGU_ACTION].to_i == 6100
			if l_params[:pgu_action_date].present? and l_params[:pgu_action_reason].present?
				msg = true
			end
		else
			if l_params[:pgu_action_reason].present?
				msg = true
			end
	 	end
	 	return msg
	end

  	def save_close_action(arg_params,arg_program_unit_id)
  		msg = nil
  		begin
      		ActiveRecord::Base.transaction do
		        	common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.event_id = 810 # "Save", closure of Program Unit
			        common_action_argument_object.program_unit_id = arg_program_unit_id
			        common_action_argument_object.client_id = session[:CLIENT_ID]
			        common_action_argument_object.pgu_action_date = arg_params[:pgu_action_date].to_date
			        common_action_argument_object.pgu_action_reason = arg_params[:pgu_action_reason].to_i
			        common_action_argument_object.selected_pgu_action = session[:SELECTED_PGU_ACTION].to_i
			        common_action_argument_object.queue_reference_id = arg_program_unit_id
			        common_action_argument_object.queue_reference_type = 6345 # "Program Unit"
			        msg = EventManagementService.process_event(common_action_argument_object)
			end
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","save_close_action",err,AuditModule.get_current_user.uid)
				msg = "Error ID: #{error_object.id} - Error occurred when submitting program unit."
        end
        return msg


  	end

  	def save_deny_action(arg_params,arg_program_unit_id)
  		# update program unit disposition status & disposition date
  		msg = "SUCCESS"
  		@selected_program_unit = ProgramUnit.find(arg_program_unit_id)
  		@selected_program_unit.disposition_reason = arg_params[:pgu_action_reason]
		@selected_program_unit.disposition_status = 6041 # Denied
		@selected_program_unit.program_unit_status = 5942 # program unit status = complete.
		@selected_program_unit.disposition_date = DateTime.now
		@selected_program_unit.disposed_by = current_user.uid
		@selected_program_unit.deny_notice_generation_flag = arg_params[:pgu_deny_notice_generation_flag]
		begin
      		ActiveRecord::Base.transaction do
      			    @selected_program_unit.save!
		        	common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.event_id = 810 # "Save", denial of Program Unit
			        common_action_argument_object.program_unit_id = arg_program_unit_id
			        common_action_argument_object.client_id = session[:CLIENT_ID]
			        common_action_argument_object.pgu_action_date = Date.today
			        common_action_argument_object.pgu_action_reason = arg_params[:pgu_action_reason].to_i
			        common_action_argument_object.selected_pgu_action = session[:SELECTED_PGU_ACTION].to_i
			        common_action_argument_object.pgu_deny_notice_generation_flag = arg_params[:pgu_deny_notice_generation_flag]
			       	# queue code.
			       	common_action_argument_object.queue_reference_type = 6345 # program unit
					common_action_argument_object.queue_reference_id = @selected_program_unit.id

			        msg = EventManagementService.process_event(common_action_argument_object)
			end
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitActionsController","save_close_action",err,AuditModule.get_current_user.uid)
				msg = "Error ID: #{error_object.id} - Error occurred when denying program unit."
        end
        return msg



  	end

  	def save_reinstate_action(arg_params,arg_program_unit_id)
  		# Check if this client is present in another active case.
  		msg = "SUCCESS"
  		if ProgramUnit.can_reopen_program_unit?(arg_program_unit_id) == true
  			msg = ProgramUnit.re_open_tanf_program(arg_program_unit_id,(Date.today),arg_params[:pgu_action_reason].to_i)
  			#Rails.logger.debug("msg = #{msg.inspect}")
   			# insert record in program participation
  			# msg = create_participation_record(arg_params,arg_program_unit_id,6043) # Open = 6043
  		else
  			msg = "This program unit cannot be reinstated, because one of the member of this program unit is in another open program unit."
  		end
  		return msg

  	end

  	# def create_participation_record(arg_params,arg_program_unit_id,arg_status)
  	# 	participation_object = ProgramUnitParticipation.new
  	# 	participation_object.program_unit_id = arg_program_unit_id
  	# 	participation_object.participation_status = arg_status
  	# 	participation_object.action_date = arg_params[:pgu_action_date]
  	# 	participation_object.status_date = Time.now.to_date
  	# 	participation_object.reason = arg_params[:pgu_action_reason]
  	# 	if participation_object.save
  	# 		msg = "SUCCESS"
  	# 	else
  	# 		msg = "Failed to create program participation record."
  	# 	end
  	# 	return msg
  	# end

  	def populate_edit_attributes(arg_action)
  		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		if arg_action == "edit"
			@pgu_action = PguAction.find(session[:NEW_PGU_ACTION_ID].to_i)
		end

		# @program_wizards = @selected_program_unit.program_wizards.order("id DESC")
		# Array
		# @action_collections = %w[ Deny Close Reinstate]

		 #  which step object to be shown on the start_check_program_eligibility_wizard.html.erb
      	@pgu_action.current_step = session[:PGU_ACTION_STEP]

      	if session[:PGU_ACTION_STEP] == "pgu_action_first" || @pgu_action.current_step == "pgu_action_first"

      		program_participation_collection = @selected_program_unit.program_unit_participations
      		if program_participation_collection.present?
      			@action_collections = CodetableItem.new
      			if @selected_program_unit.service_program_id != 3 # TEA Diversion only once per lifetime - and at the time of activating program unit both open & close participation records are entered.
	      			sorted_participation_list = program_participation_collection.order("id DESC")
	      			# Rule - If latest status is Closed only -Re instate is allowed for 30 days after closure date.
	      			participation_object = sorted_participation_list.first
	      			if participation_object.participation_status == 6044 # Close
	      				# Close
	      				@action_collections = CodetableItem.items_to_include(147,6101,"Only Reinstate Action is shown")
	      			else
	      				# Open - Only two status are there.
	      				@action_collections = CodetableItem.items_to_include(147,6100,"Only Close Action is shown")
	      			end
	      		end
      			# If latest Status is Open - Close only is allowed.
      		else
	   			#Only Deny action is allowed.

      			# @action_collections = CodetableItem.item_list(147,"Program Unit Actions")
      			@action_collections = CodetableItem.items_to_include(147,6099,"Only Deny Action is shown")
      		end

      	else
      		# last step
      		@current_action = session[:SELECTED_PGU_ACTION].to_i
      		@transportation_bonus_amount = SystemParam.get_key_value(9,"TRANSPORTATION_BONUS_AMOUNT","transportation bonus of $200.00")
      		case session[:SELECTED_PGU_ACTION]
				when "6100" # close
					if @selected_program_unit.service_program_id == 3 or @selected_program_unit.service_program_id == 1
						@action_reasons = CodetableItem.get_code_table_values_by_system_params("TEA_CLOSE_REASONS")
					elsif @selected_program_unit.service_program_id ==4
						@action_reasons = CodetableItem.get_code_table_values_by_system_params("WORK_PAYS_CLOSE_REASONS")
					end

				when "6099" # Deny
					if @selected_program_unit.service_program_id == 3 or @selected_program_unit.service_program_id == 1
						@action_reasons = CodetableItem.get_code_table_values_by_system_params("TEA_DENIAL_REASONS")
					elsif @selected_program_unit.service_program_id == 4
						@action_reasons = CodetableItem.get_code_table_values_by_system_params("WORK_PAYS_DENIAL_REASONS")
					end
				when "6101" # Reopen or Reinstate
					@action_reasons = CodetableItem.item_list(148,"Reinstate Reasons")
			end
      	end
  	end

end
