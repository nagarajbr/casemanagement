class ProgramWizardsController < AttopAncestorController
	#  Author: Manoj Patil
	#  Date: 09/30/2014
	# Description : Program Wizard for determing payment eligibility for program Unit for selected Month.

	def cancel_eligibility_determination_wizard
		# Delete program_wizard & Program_benefit_meber if No Eligibility Determination step complete
		ProgramWizard.manage_program_wizard_cancellation(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
		# redirect_to program_wizards_path
		redirect_to index_eligibility_determination_runs_path(params[:program_unit_id].to_i)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","cancel_eligibility_determination_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when cancelling eligibility determination."
		redirect_to_back
	end


	def program_unit_eligibility_wizard_initialize
		session[:PROGRAM_WIZARD_STEP] = session[:NEW_PROGRAM_WIZARD_ID]  =  session[:PRIMARY_BENEFICIARY] =  nil
		# create new wizard ID.
		program_wizard_object = ProgramWizard.manage_program_wizard_creation(params[:program_unit_id].to_i)
		session[:NEW_PROGRAM_WIZARD_ID] = program_wizard_object.id
		#  Get the application ID for the selected Program Unit
		l_program_unit_object = ProgramUnit.find(params[:program_unit_id].to_i)

		# primary_member_collection = ProgramUnitMember.get_primary_beneficiary(l_program_unit_object.id)
		# if primary_member_collection.present?
		# 	session[:PRIMARY_BENEFICIARY] = primary_member_collection.first.client_id
		# end

		primary_contact = PrimaryContact.get_primary_contact(l_program_unit_object.id, 6345)
		if primary_contact.present?
			session[:PRIMARY_BENEFICIARY] = primary_contact.client_id
		end

		@run_month_description = " "
		redirect_to start_eligibility_determination_wizard_path(l_program_unit_object.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","program_unit_eligibility_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when initializing eligibility determination wizard."
		redirect_to_back
	end


	def start_eligibility_determination_wizard
		objects_required_for_eligibility_determination_wizard(params[:program_unit_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","start_eligibility_determination_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when running eligibility determination."
		redirect_to_back
	end

	def process_eligibility_determination_wizard
		#  similar to Update REST action for Post of start_eligibility_determination_wizard
		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.
		# Rule 3 - After Processing is done send it back to start_check_program_eligibility_wizard - because that is where
		#          views corresponding to each step is opened.

		# similar to UPDATE REST action.
		@client = Client.find(session[:CLIENT_ID])
		# similar to EDIT REST action.
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
  		@program_wizard = ProgramWizard.find(session[:NEW_PROGRAM_WIZARD_ID].to_i)
      	#  first step is assigned to current step -when session[:PROGRAM_WIZARD_STEP] is null
      	@program_wizard.current_step = session[:PROGRAM_WIZARD_STEP]
      	# Manage steps -start
      	if params[:back_button].present?
      		 @program_wizard.previous_step
      	elsif @program_wizard.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @program_wizard.next_step
        end
       session[:PROGRAM_WIZARD_STEP] = @program_wizard.current_step
       # Manage steps -end

        # what step to process?
		if @program_wizard.get_process_object == "program_wizard_first" && params[:next_button].present?
			l_params = program_wizard_params
			# fail
			if l_params.present?
				ldt_mm_yyyy = l_params.to_date
				@program_wizard.run_month = ldt_mm_yyyy.strftime("01/%m/%Y").to_date
				@program_wizard.save
				redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
			else
				@program_wizard.previous_step
			 	session[:PROGRAM_WIZARD_STEP] = @program_wizard.current_step
			 	# flash[:alert] = "Eligibility Detrmination Month can't be blank"
			 	objects_required_for_eligibility_determination_wizard(@selected_program_unit.id)
			 	@program_wizard.errors[:base] = "Eligibility detrmination month can't be blank."
			 	render :start_eligibility_determination_wizard
			end
		elsif @program_wizard.get_process_object == "program_wizard_second" && params[:next_button].present?

			error_messages_found = false
			@program_unit_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(@program_wizard.id)
			if @program_unit_benefit_members.present?
				if @program_unit_benefit_members.size < 2
					error_messages_found = true
					error_message = "Two benefit members are required to proceed to next step."
				end
				if error_messages_found == false
					# Primary Member(self of the Program Unit) should be selected to proceed to Next step
					primary_member_found = ProgramBenefitMember.primary_member_selected(@program_wizard.id)
					if primary_member_found == "N"
						error_message =  "Primary member(self of program unit) is required to proceed to next step."
						error_messages_found = true
					end
				end

				if error_messages_found == false
					# Primary Member(self of the Program Unit) should be selected to proceed to Next step
					active_child_found = ProgramBenefitMember.atleast_one_active_child_present(@program_wizard.id)
					if active_child_found == "N"
						error_message =  "No active child present in the selected benefit members, atleast one active child should be present to proceed to next step."
						error_messages_found = true
					end
				end

				if error_messages_found == false

					# Rule : For TEA diversion (3) or Workpays (4) one active adult is a must.
					if @selected_program_unit.service_program_id == 3 ||  @selected_program_unit.service_program_id == 4

						active_adult_found = ProgramBenefitMember.atleast_one_active_adult_present(@program_wizard.id)
						if active_adult_found == "N"
							error_message =  "No active adult present in the selected benefit members, atleast one active adult should be present to proceed to next step."
							error_messages_found = true
						end
					end
				end

				# If Caretaker is found , he should be adult
				if error_messages_found == false
					# Rule : If Caretaker is found , he should be adult
					care_taker_collection = ProgramBenefitMember.get_care_taker_list(@program_wizard.id)
					if care_taker_collection.present?
						care_taker_object = care_taker_collection.first
						client_object = Client.find(care_taker_object.client_id)
						ll_check_age = SystemParam.get_key_value(6,"child_age","get check age - which returns 19").to_i
						ll_caretake_age = CommonUtil.get_age(client_object.dob)
						if  ll_caretake_age < ll_check_age
							error_message =  "Caretaker's age is #{ll_caretake_age}, caretaker should be adult."
							error_messages_found = true
						end
					end
				end



			else
				error_message =  "Two benefit members are required to proceed to next step."
				error_messages_found = true
				# @program_wizard.previous_step
				# session[:PROGRAM_WIZARD_STEP] = @program_wizard.current_step
				# flash[:alert] = error_message
			end

			if error_messages_found == true
				@program_wizard.previous_step
				session[:PROGRAM_WIZARD_STEP] = @program_wizard.current_step
				# flash[:alert] = error_message
				# redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
				objects_required_for_eligibility_determination_wizard(@selected_program_unit.id)
				@program_wizard.errors[:base] = error_message
				render :start_eligibility_determination_wizard
			else
				redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
			end
		 	# ED results
				# redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
		elsif @program_wizard.current_step == "program_wizard_last"
			fts = FamilyTypeService.new
			family_type_struct = FamilyTypeStruct.new
			family_type_struct = fts.determine_family_type_for_program_wizard(@program_wizard.id)

			if family_type_struct.family_type != 0
				appl_eligibilty_servc = ApplicationEligibilityService.new
				# appl_eligibilty_servc.determine_program_unit_eligibilty(family_type_struct)
				# This is done
				family_type_struct = fts.determine_family_type_for_program_wizard(@program_wizard.id)
				# Case type is saved in program wizard -start - 03/25/2015
				@program_wizard.case_type = family_type_struct.case_type_integer
				@program_wizard.save
				# Case type is saved in program wizard -end
				family_type_struct.run_month = @program_wizard.run_month
				family_type_struct.run_id = @program_wizard.run_id
				family_type_struct.month_sequence = @program_wizard.month_sequence
				family_type_struct.ed_activie_members_list = ProgramBenefitMember.get_active_program_benefit_memebers_from_wizard_id(@program_wizard.id)
				appl_eligibilty_servc.determine_program_wizard_eligibilty(family_type_struct)
				EligibilityDetermineService.common_rules_for_all_tanf_service_programs(family_type_struct,@program_wizard.id)
				case @selected_program_unit.service_program_id
				when 1
					# TEA
					str_budget = BenefitCalculator.sum_budget_cal(@selected_program_unit.service_program_id,0,nil,@selected_program_unit.id, @program_wizard.run_id, 355)

					if str_budget.error_flag == 'Y'
						flash[:alert] = str_budget.error_message
					else
						# pass the budget information from above to determine resource
						# get the rule id for resource (category 25)


						# Manoj Patil 05/21/2015 - commented Resource ED calculation - as it is giving run time error - need to revisit later
						 effective_begin_date = str_budget.str_months[0].month.to_datetime
						 resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
						 str_budget.rule_id = resourec_rule_id
						 # Run the resourec eligibility rules
						 ResourceModule.sum_resource(str_budget)
						 EligibilityDetermineService.tea_program_eligibility_validations(family_type_struct,@program_wizard.id)
						# demo code for snap -START
						# step1  : create snap program unit
						# step 2 : create snap program unit members
						# step 3 : create snap program wizard object
						# step 4 : create snap program wizard object
						# step 5 : call ed budget calculation
						snap_program_unit = ProgramUnit.demo_test_function(@selected_program_unit)
						if snap_program_unit.present?
							snap_program_wizard_object = ProgramWizard.where("program_unit_id = ?",snap_program_unit.id).last
							BenefitCalculator.sum_budget_cal(snap_program_unit.service_program_id, 0,nil,snap_program_unit.id, snap_program_wizard_object.run_id, 355)
						end
						# demo code for snap - END
                    end

				when 3
					# TEA DIVERSION
					str_budget =  BenefitCalculator.sum_budget_cal(@selected_program_unit.service_program_id,0,nil, @selected_program_unit.id, @program_wizard.run_id, 355)
					resourec_rule_id = BenefitCalculator.bu_rule_id(4,'25',effective_begin_date,nil)
					str_budget.rule_id = resourec_rule_id
					ResourceModule.sum_resource(str_budget)
					EligibilityDetermineService.tea_diversion_program_eligibility_validations(family_type_struct,@program_wizard.id)
				when 4
					# WORKPAYS
					BenefitCalculator.sum_budget_cal(@selected_program_unit.service_program_id,0,nil, @selected_program_unit.id, @program_wizard.run_id, 357)
					EligibilityDetermineService.work_pays_program_eligibility_validations(family_type_struct,@program_wizard.id)
				end
				EligibilityDetermineService.update_program_month_summaries_ed_indicator(@program_wizard.run_id,@program_wizard.month_sequence)
				@client_program_units = ProgramUnit.get_completed_program_units(@selected_program_unit.id)
				@program_wizards = @selected_program_unit.program_wizards
				details_for_run_id(@selected_program_unit.id,@program_wizard.id)
				redirect_to show_program_wizard_run_id_details_path(@selected_program_unit.id,@program_wizard.id)
			else
					#  flash message No child present in composition.
				@program_wizard.current_step = @program_wizard.steps[1]
				session[:PROGRAM_WIZARD_STEP] = @program_wizard.current_step
				flash[:alert] = "Unable to determine the case type."
				redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
			end

		else
			# previous button is clicked.
			redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
		end

     rescue => err
		  error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","process_eligibility_determination_wizard",err,current_user.uid)
		 flash[:alert] = "Error ID: #{error_object.id} - Error occurred when running eligibility determination."
		 redirect_to_back
	end




	def update_retain_indicator_for_run_id
		program_wizard_object = ProgramWizard.find(params[:program_wizard_id])
		if program_wizard_object.retain_ind == "Y"
			program_wizard_object.retain_ind = "N"
			flash[:notice] = "Selected run ID will be disposed."
		else
			program_wizard_object.retain_ind = "Y"
			flash[:notice] = "Selected run ID will be retained."
		end
		program_wizard_object.save
		redirect_to index_eligibility_determination_runs_path(params[:program_unit_id].to_i)
	rescue => err
		CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","update_retain_indicator_for_run_id",err,current_user.uid)
		redirect_to_back
	end

	def show_program_wizard_run_id_details
		# This action is called from show link of Program Unit Approve process.
		@queue_message_to_user = nil
		@show_approve_reject_button = false
		# @show_ready_for_assessment_button = false
		# @message_ready_for_assessment = ""
		details_for_run_id(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
		@program_unit_closed_for_more_30_days = ProgramUnitParticipation.is_program_unit_participation_status_closed_for_more_than_30days(params[:program_unit_id])
		@case_type = @selected_program_wizard.case_type
		@submit_payment_button_show =  ProgramWizard.manage_submit_payment_button(@selected_program_wizard.program_unit_id,@selected_program_wizard.created_at,@selected_program_wizard.run_month)

		# if @case_type != 6048
		# 	# Non Child only case needs case management - hence forcing to do assessment/cpp before activating case.
		# 	if (@selected_program_unit.service_program_id == 1 || @selected_program_unit.service_program_id == 4)
		# 		# TEA & work pays
		# 		# check if cpp is complete?
		# 		# Rules
		# 		# 1. if CPP is incomplete then @show_ready_for_assessment_and_cpp_button = true
		# 		 # ls_return_message_hash = ProgramUnit.check_is_cpp_signed_by_pgu_members(arg_run_id,arg_month_sequence)
		# 		 ls_return_message_hash = ProgramUnit.check_is_cpp_signed_by_pgu_members(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
		# 		 if  ls_return_message_hash["message"] != "SUCCESS"
		# 		 	@show_ready_for_assessment_button = true
		# 		 	li_client_id = ls_return_message_hash["client_id"]
		# 		 	client_object = Client.find(li_client_id)
		# 		 	# @message_ready_for_assessment = " Complete CPP for client:#{client_object.get_full_name}"
		# 		 	@message_ready_for_assessment = ls_return_message_hash["message"]
		# 		 end
		# 	else
		# 		if @selected_program_unit.service_program_id == 3
		# 			# tea diversion
		# 			# check if only assessment is completed.
		# 			ls_return_message_hash = ProgramUnit.check_is_assessment_complete_for_adult_pgu_members(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
		# 			# logger.debug("ls_return_message_hash = #{ls_return_message_hash.inspect}")
		# 			if  ls_return_message_hash["message"] != "SUCCESS"
		# 			 	@show_ready_for_assessment_button = true
		# 			 	@message_ready_for_assessment = ls_return_message_hash["message"]
		# 			end
		# 		end
		# 	end

			#  if case manager is assigned - then show_ready_for_assessment_and_cpp_button should be false.
			# @show_ready_for_assessment_button - Is sending request to assign case manager for the case
			# if @selected_program_unit.case_manager_id.present?
			# 	@show_ready_for_assessment_button = false
			# end
		# end

		#  LOgic for Button show.
		@reference_id_state = WorkQueue.get_the_state_of_the_reference_id(6345,params[:program_unit_id].to_i)

		# if @selected_program_unit.state == 6373 # requested
		if 	@reference_id_state == 6562
			# "Ready for Program Unit Activation" QUEUE
			@show_approve_reject_button = true
			program_unit_task_owner =  ProgramUnitTaskOwner.get_program_unit_task_owner(@selected_program_unit.id,6620) # Benefit AMount Approval
		    if program_unit_task_owner.present?
		    	if program_unit_task_owner.ownership_user_id == current_user.uid
		    		# @show_approve_reject_button = true
		    	else
		    		# user_object = User.find(program_unit_task_owner.ownership_user_id)
		    		ls_user_name = User.get_user_full_name(program_unit_task_owner.ownership_user_id)
		    		@queue_message_to_user = "Approve benefit amount task for this program unit is assigned to user: #{ls_user_name}. He/she will review and approve the benefit amount."
		    	end

		    else
		    	# @queue_message_to_user = "Request to Approve First Time Benefit amount is in 'First Time Benefit Amount Approval Queue' users subscribed to it, will review and approve it."
		    	@queue_message_to_user = "Program unit is in queue:'Ready for Program Unit Activation',not assigned to any user.Users subscribed to that queue will be able to approve benefit amount."
		    end

		end


    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","update_retain_indicator_for_run_id",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid eligibility determination run ID"
		redirect_to_back
	end


	def no_cpp_warning
		wizard_id = params[:program_wizard_id]
		# logger.debug("MNP4 - @message_text in no_cpp_warning = #{@message_text}")
		program_wizard_object = ProgramWizard.find(wizard_id)
		@selected_program_unit_id = program_wizard_object.program_unit_id
		@program_wizard_id = program_wizard_object.id
		@client_id = params[:client_id]
		@client_object = Client.find(@client_id)
		# does this client have assessment id.
		session["CLIENT_ID"] = @client_id
		assessment_collection = ClientAssessment.get_client_assessments(@client_id)
		if assessment_collection.present?
			@assessment_id = assessment_collection.first.id
		else
			@assessment_id = 0
		end
	end

	def submit_program_wizard_run_id
		@client = Client.find(session[:CLIENT_ID])
		l_wizard_id = params[:program_wizard_id]
		program_wizard_object = ProgramWizard.find(l_wizard_id)
		program_unit_state = WorkQueue.get_the_state_of_the_reference_id(6345,program_wizard_object.program_unit_id)
		ret_hash = ProgramUnit.can_submit_program_run_id?(program_wizard_object.run_id,program_wizard_object.month_sequence)
		if ret_hash[:can_submit] == true
			begin
	      		ActiveRecord::Base.transaction do
			        msg = ProgramUnit.submit_payment(program_wizard_object.id)
			        if msg == "SUCCESS"
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
				        common_action_argument_object.event_id = 683 # Submit Payment
				        common_action_argument_object.program_wizard_id = program_wizard_object.id
				        common_action_argument_object.client_id = @client.id
				        common_action_argument_object.program_unit_id = program_wizard_object.program_unit_id

				        # Queue related variables.
				        common_action_argument_object.queue_reference_type = 6345 # program unit
		            	common_action_argument_object.queue_reference_id = program_wizard_object.program_unit_id
				        ls_flash_message = EventManagementService.process_event(common_action_argument_object)
						if ls_flash_message == "SUCCESS"
							flash[:notice] = "Payment submitted successfully."
							redirect_to index_eligibility_determination_runs_path(params[:program_unit_id].to_i)
						else
							flash[:alert] = msg
							redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
						end
					else
						flash[:alert] = ls_flash_message
						redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
					end

				  	if program_unit_state == 6558 #Ready for eligibility determination queue
			  			ls_msg = ProgramWizard.mark_this_run_id_for_planning(program_wizard_object.id)
				  	end
				end
				rescue => err
					error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","submit_program_wizard_run_id",err,AuditModule.get_current_user.uid)
					flash[:alert] = "Error ID: #{error_object.id} - Error occurred when submitting program unit."
					redirect_to_back
	        end
		else
			if ret_hash[:error_msg].include?("Career") == true
				redirect_to no_cpp_warning_path(program_wizard_object.id,ret_hash[:client_id])
			else
				flash[:alert] = ret_hash[:error_msg]
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","submit_program_wizard_run_id",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when submitting program unit."
		redirect_to_back
	end


	# TEA DIVERSION ACTIVATE/SUBMIT -START

	def new_submit_tea_diversion_payment_run_id
		error_msg = ""
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@selected_program_wizard = ProgramWizard.find(params[:program_wizard_id].to_i)

		@client = Client.find(session[:CLIENT_ID])
		program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
	    if program_month_summary_collection.present?
	        program_month_summary_object = program_month_summary_collection.first
	        if program_month_summary_object.budget_eligible_ind == "Y"
	            lb_proceed = true
	            error_msg = ""
	        else
	           lb_proceed = false
	           error_msg = "This program unit cannot be assessed because, client is not eligible for benefits."
	        end
	    else
	         lb_proceed = false
	         error_msg = "This program unit cannot be assessed because, client is not eligible for benefits."
	    end

	    # ED month should be current month check - no retro.
	    #   if  lb_proceed == true
	    #     ldt_run_month = @selected_program_wizard.run_month
	    #     ldt_current_month = Date.today.strftime("01/%m/%Y").to_date - 2.months
	    #     if ldt_run_month < ldt_current_month
				 # lb_proceed = false
	    #     	 error_msg = "You are submitting retro month payment, Payment month should be current month"
	    #     end
	    #   end

		# ret_hash = ProgramUnit.can_activate_program_unit?(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
		# lb_boolean = ret_hash[:can_activate]
		if lb_proceed == true
			@program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
			@program_benefit_detail = @program_benefit_detail_collection.first
			formated_run_month = @selected_program_wizard.run_month.strftime("%m/%Y")
			@run_month_description = "for month: #{formated_run_month}"
		else
			flash[:alert] = error_msg
			redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","new_submit_tea_diversion_payment_run_id",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when activating TEA diversion program unit."
		redirect_to_back
	end

	def create_submit_tea_diversion_payment_run_id

		# Rule 1: Benefit amount cannot be more than 3 times monthly payment.
		# Rule 2 : SEnd Request to Approve First Time Benefit amount to processing office.
		lb_saved = false
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		program_unit_object = @selected_program_unit
		@selected_program_wizard = ProgramWizard.find(params[:program_wizard_id].to_i)
		program_wizard_object = @selected_program_wizard
		formated_run_month = @selected_program_wizard.run_month.strftime("%m/%Y")
		@run_month_description = "for month: #{formated_run_month}"
		@program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
		@program_benefit_detail = @program_benefit_detail_collection.first
		l_params = tea_diversion_params
		if l_params[:reimbursed_amount].present?
			if l_params[:reimbursed_amount].to_f > @program_benefit_detail.program_benefit_amount
				# flash[:alert] = "Reimbursement Amount cannot be more than Maximum TEA diversion amount"
				@program_benefit_detail.errors[:base] = "Reimbursement amount cannot be more than maximum TEA diversion amount."
				# redirect_to new_submit_tea_diversion_payment_run_id_path(@selected_program_wizard.program_unit_id,@selected_program_wizard.id)
				render :new_submit_tea_diversion_payment_run_id
			else
				if @selected_program_unit.state == 6167
					@selected_program_unit.reason = nil
					@selected_program_unit.reject_to_complete
				end
				# Sync benefit member status to pgu members.
				ProgramUnit.sync_program_unit_member_status_with_benefit_member_status(program_unit_object.id,program_wizard_object.id)
	          	# update case type of program wizard and sync it to program unit case type
	        	ProgramWizard.update_case_type(program_wizard_object.id)
	        	ProgramWizard.mark_this_run_id_for_planning(program_wizard_object.id)

	        	# self_of_pgu_collection = ProgramUnitMember.get_primary_beneficiary(program_unit_object.id)
        		# self_of_pgu_object = self_of_pgu_collection.first
        		# client_object = Client.find(self_of_pgu_object.client_id)

        		primary_contact = PrimaryContact.get_primary_contact(program_unit_object.id, 6345)
        		if primary_contact.present?
        			client_object = Client.find(primary_contact.client_id)
        		end
				 #  Table 3 :program_benefit_details
				# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.event_id = 684 # "Eligible for Planning event"
		        common_action_argument_object.program_wizard_id = @selected_program_wizard.id
		        common_action_argument_object.program_unit_id = @selected_program_unit.id
		        common_action_argument_object.client_id = client_object.id
		        common_action_argument_object.user_id = nil
		        # manoj 04/21/2016 - WHEN TEA DIVERSION REJECTED PGU IS SUBMITTED AGAIN - THIS IS USED TO CREATE TASK TO SUPERVISOR TO APPROVE AGAIN.
		        # if program task owner to approve benefit amount is present use it to send task (approve benefit amount)to him - else don't create task (2172)
		        program_unit_task_owner_collection  = ProgramUnitTaskOwner.where("program_unit_id = ? and ownership_type = 6620 and ownership_user_id is not null",@selected_program_unit.id).order("id DESC")
		        if program_unit_task_owner_collection.present?
		        	program_unit_task_owner_object = program_unit_task_owner_collection.first
		        	common_action_argument_object.user_id = program_unit_task_owner_object.ownership_user_id
		        end

		         # Queue related variables.
		        common_action_argument_object.queue_reference_type = 6345 # program unit
            	common_action_argument_object.queue_reference_id = program_unit_object.id

		        begin
					ActiveRecord::Base.transaction do
				        # step2: call common method to process event.
				        ls_msg = EventManagementService.process_event(common_action_argument_object)
				        if ls_msg == "SUCCESS"

				        	@program_benefit_detail.reimbursed_amount = l_params[:reimbursed_amount].to_f
      						lb_saved = @program_benefit_detail.save!
						else
							lb_saved = false
						end
				  	end
			  	rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","create_submit_tea_diversion_payment_run_id",err,AuditModule.get_current_user.uid)
			  		lb_saved = false
			  		ls_msg = "Request for approval of benefit amount failed for more details refer to error ID: #{error_object.id}."
		        end

				if lb_saved

					flash[:notice] = "Eligibility determination completed for this program unit."
				else
					flash[:alert] = ls_msg
				end
				# redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
				redirect_to alerts_path
			end
		else
			@program_benefit_detail.errors[:base] = "Reimbursed amount is required."
			render :new_submit_tea_diversion_payment_run_id
		end

	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","create_submit_tea_diversion_payment_run_id",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when activating TEA diversion program unit."
	 	redirect_to_back
	end

	#  check if edit_submit_tea_diversion_payment_run_id action is needed - 07/27/2015 = Manoj Patil

	def edit_submit_tea_diversion_payment_run_id
		#  THis action is used for submitting tea diversion payments after first time activation is done
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@selected_program_wizard = ProgramWizard.find(params[:program_wizard_id].to_i)
		ret_hash = ProgramUnit.can_activate_program_unit?(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
		lb_boolean = ret_hash[:can_activate]
		if lb_boolean
			@program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
			@program_benefit_detail = @program_benefit_detail_collection.first
			formated_run_month = @selected_program_wizard.run_month.strftime("%m/%Y")
			@run_month_description = "for month: #{formated_run_month}"
		else
			# flash[:alert] = "This Program Unit cannot be Submitted because, client is not eligible for benefits "
			flash[:alert] = ret_hash[:error_msg]
			redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","edit_submit_tea_diversion_payment_run_id",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when submitting TEA diversion payment."
		redirect_to_back
	end

#  check if update_submit_tea_diversion_payment_run_id action is needed - 07/27/2015 = Manoj Patil
	def update_submit_tea_diversion_payment_run_id
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@selected_program_wizard = ProgramWizard.find(params[:program_wizard_id].to_i)
		formated_run_month = @selected_program_wizard.run_month.strftime("%m/%Y")
		@run_month_description = "for month: #{formated_run_month}"
		@program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
		@program_benefit_detail = @program_benefit_detail_collection.first

			l_params = tea_diversion_params
			if l_params[:reimbursed_amount].to_f > @program_benefit_detail.program_benefit_amount
				flash[:alert] = "Reimbursement amount cannot be more than maximum TEA diversion amount."
				redirect_to edit_submit_tea_diversion_payment_run_id_path(@selected_program_wizard.program_unit_id,@selected_program_wizard.id)
			else
				msg = ProgramUnit.submit_tea_diversion_payment(params[:program_wizard_id].to_i,l_params[:reimbursed_amount].to_f)
				if msg == "SUCCESS"
					flash[:notice] = "TEA diversion payment submitted successfully."
					redirect_to index_eligibility_determination_runs_path(params[:program_unit_id].to_i)
				else
					flash[:alert] = msg
					redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
				end
			end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","update_submit_tea_diversion_payment_run_id",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when submitting TEA diversion payment."
		redirect_to_back
	end


	def no_assessment_warning
		wizard_id = params[:program_wizard_id]
		program_wizard_object = ProgramWizard.find(wizard_id)
		@selected_program_unit_id = program_wizard_object.program_unit_id
		@program_wizard_id = program_wizard_object.id
		@client_id = params[:client_id]
		@client_object = Client.find(@client_id)
		# does this client have assessment id.
		session["CLIENT_ID"] = @client_id
		assessment_collection = ClientAssessment.get_client_assessments(@client_id)
		if assessment_collection.present?
			@assessment_id = assessment_collection.first.id
		else
			@assessment_id = 0
		end

	end

	# TEA DIVERSION ACTIVATE/SUBMIT -END



	# eligibility summary Menu actions -start


	def index_eligibility_determination_runs
		#  Index of Run ID's or Wizard Ids
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		session[:PROGRAM_UNIT_ID] = @selected_program_unit.id

		# Manoj 02/24/2016 - called from workload management where session[CLIENT_ID] is not set
		# if session[:CLIENT_ID].blank?
			primary_contact = PrimaryContact.get_primary_contact_for_program_unit(session[:PROGRAM_UNIT_ID].to_i)
			if primary_contact.present?
					session[:CLIENT_ID] = primary_contact.client_id
			else
				pgu_adults_collection =ProgramUnitMember.get_adults_in_the_program_unit(session[:PROGRAM_UNIT_ID].to_i)
				if pgu_adults_collection.present?
					pgu_adult_object = pgu_adults_collection.first
					session[:CLIENT_ID] =pgu_adult_object.client_id
				else
					pgu_member_collection =ProgramUnitMember.sorted_program_unit_members(session[:PROGRAM_UNIT_ID].to_i)
					pgu_member_object = pgu_member_collection.first
					session[:CLIENT_ID] =pgu_member_object.client_id
				end
			end
		# end

		@client = Client.find(session[:CLIENT_ID])
		set_household_member_info_in_session(session[:CLIENT_ID])
		@program_wizards = @selected_program_unit.program_wizards.order("id DESC")
		# @client_program_units = ProgramUnit.get_completed_program_units_for_focus_client(@client.id)
		# @client_program_units = ProgramUnit.get_completed_program_units(params[:program_unit_id].to_i)
		# @program_unit_closed_for_more_30_days = ProgramUnitParticipation.is_program_unit_participation_status_closed_for_more_than_30days(params[:program_unit_id])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","index_eligibility_determination_runs",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	# def view_summary_for_program_wizard_id
	# 	details_for_run_id(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
	#  rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","view_summary_for_program_wizard_id",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Program Unit ID"
	# 	redirect_to index_eligibility_determination_runs_path(params[:program_unit_id].to_i)
	# end

	# eligibility summary Menu actions -end

	# Manoj 03/18/2015
	# new way of adding benefit member -start
	def new_benefit_member
		@program_wizard = ProgramWizard.find(params[:program_wizard_id])
		@selected_program_unit = ProgramUnit.find(@program_wizard.program_unit_id)
		@program_unit_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_and_client_details_from_wizard_id(@program_wizard.id)
		@available_members = ProgramBenefitMember.get_available_program_unit_members_query(@program_wizard.id)
	   #items_include = [4468,4469,4470,4471]
		# @program_unit_member_status = CodetableItem.items_to_include(84,items_include," benefit member status")
      	@program_unit_member_status = CodetableItem.get_code_table_values_by_system_params((@selected_program_unit.service_program_id).to_s)
		@program_unit_benefit_member_object = ProgramBenefitMember.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","new_benefit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when creating program unit member."
		redirect_to_back
	end

	def create_benefit_member

		@program_wizard = ProgramWizard.find(params[:program_wizard_id])
		@selected_program_unit = ProgramUnit.find(@program_wizard.program_unit_id)
		@program_unit_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_and_client_details_from_wizard_id(@program_wizard.id)
		@available_members = ProgramBenefitMember.get_available_program_unit_members_query(@program_wizard.id)
        # items_include = [4468,4469,4470,4471]
		# @program_unit_member_status = CodetableItem.items_to_include(84,items_include," benefit member status")
		@program_unit_member_status = CodetableItem.get_code_table_values_by_system_params((@selected_program_unit.service_program_id).to_s)
		@program_unit_benefit_member_object = ProgramBenefitMember.new
		l_params = benefit_member_params
		if l_params[:client_id].present?
			@client_death_date_present = Client.date_of_death_present(l_params[:client_id])
	    end
		if params[:save_and_add].present?
			# Handle save and add here
			@program_unit_benefit_member_object = set_benefit_member_data_for_add(@program_unit_benefit_member_object,
				                                                                  l_params,
				                                                                  @program_wizard.id)

           if @client_death_date_present == true and l_params[:member_status].to_i == 4468
           		   ls_name = Client.get_client_full_name_from_client_id(l_params[:client_id])
			       @program_unit_benefit_member_object.errors[:base] = "(#{ls_name}) is deceased and cannot be added as active member."
				   render :new_benefit_member
		   elsif @program_unit_benefit_member_object.save
				   redirect_to new_benefit_member_path
			else
				render :new_benefit_member
			end
		end

		if params[:save_and_exit].present?

			# Handle save and add exit
			@program_unit_benefit_member_object = set_benefit_member_data_for_add(@program_unit_benefit_member_object,
				                                                                  l_params,
				                                                                  @program_wizard.id)
			if @client_death_date_present == true and l_params[:member_status].to_i == 4468
			        ls_name = Client.get_client_full_name_from_client_id(l_params[:client_id])
			        @program_unit_benefit_member_object.errors[:base] = "(#{ls_name}) is deceased and cannot be added as active member."
				    render :new_benefit_member
		   elsif @program_unit_benefit_member_object.save
				    redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
			else
				render :new_benefit_member
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","create_benefit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when saving program unit member."
		redirect_to_back

	end

	def destroy_program_unit_benefit_member
		@program_wizard = ProgramWizard.find(params[:program_wizard_id])
		@selected_program_unit = ProgramUnit.find(@program_wizard.program_unit_id)
		@program_unit_benefit_member_object = ProgramBenefitMember.find(params[:program_benefit_member_id])
		@program_unit_benefit_member_object.destroy
		# update the member sequence
		ProgramBenefitMember.reset_member_sequence_for_benefit_members(@program_wizard.id)
		flash[:alert] = "Selected program unit benefit member deleted successfully."
		redirect_to start_eligibility_determination_wizard_path(@selected_program_unit.id)
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnitsController","destroy_program_unit_member",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when deleting program unit member."
		redirect_to_back
	end

	# def request_for_approval_of_program_unit

	# 	# Only TEA and Work pays calls this ACTIOn
	# 		# create a work task to processing office of the program unit.
	# 		li_program_unit_id =params[:program_unit_id].to_i
	# 		@client = Client.find(session[:CLIENT_ID])
	# 		lb_saved = true
	# 		l_wizard_id = params[:program_wizard_id]
	# 		program_wizard_object = ProgramWizard.find(l_wizard_id)
	# 		ret_hash = ProgramUnit.can_activate_program_unit?(program_wizard_object.run_id,program_wizard_object.month_sequence)
	# 		lb_boolean = ret_hash[:can_activate]

	# 		if lb_boolean


	# 			program_unit_object = ProgramUnit.find(li_program_unit_id)
	# 			if program_unit_object.state == 6167
	# 				program_unit_object.reason = nil
	# 				program_unit_object.reject_to_complete
	# 			end

	# 			# step1 : Populate common event management argument structure
	# 			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	# 	        common_action_argument_object.event_id = 682 # "Request for Approval of Program Unit"
	# 	        common_action_argument_object.program_wizard_id = program_wizard_object.id
	# 	        common_action_argument_object.program_unit_id = program_unit_object.id
	# 	        common_action_argument_object.client_id = @client.id

	# 	        # Queue related functionality.
	# 	        common_action_argument_object.queue_reference_type = 6378 # program wizard
	#     		common_action_argument_object.queue_reference_id = program_wizard_object.id

	# 	        begin
	# 				ActiveRecord::Base.transaction do
	# 			        # step2: call common method to process event.
	# 			        ls_msg = EventManagementService.process_event(common_action_argument_object)
	# 			        if ls_msg == "SUCCESS"
	# 			        	lb_saved = program_unit_object.request
	# 						unless lb_saved
	# 							ls_msg = program_unit_object.errors.full_messages.last
	# 						end
	# 					else
	# 						lb_saved = false
	# 					end
	# 			  	end
	# 		  	 rescue => err
	# 		  	 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","request_for_approval_of_program_unit",err,AuditModule.get_current_user.uid)
	# 		  	 	lb_saved = false
	# 		  	 	ls_msg = "Request failed- for more details refer to Error ID: #{error_object.id}"
	# 	        end

	# 			if lb_saved
	# 				ls_processing_office = CodetableItem.get_short_description(program_unit_object.processing_location)
	# 				flash[:notice] = "Request to Approve the program unit is successful."
	# 			else
	# 				flash[:alert] = ls_msg
	# 			end

	# 			redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
	# 		else
	# 			if ret_hash[:error_msg].include?("Career") == true
	# 				# logger.debug("MNP3 -ret_hash[:error_msg] in request_for_approval_of_program_unit = #{ret_hash[:error_msg]}")
	# 				# redirect_to no_cpp_warning_path(program_wizard_object.id,ret_hash[:client_id],ret_hash[:error_msg].to_s)
	# 				redirect_to no_cpp_warning_path(program_wizard_object.id,ret_hash[:client_id])

	# 			else
	# 				flash[:alert] = ret_hash[:error_msg]
	# 				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
	# 			end
	# 		end
	# 	 rescue => err
	# 	 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","request_for_approval_of_program_unit",err,current_user.uid)
	# 	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when requesting for approval of program_unit"
	# 	 	redirect_to_back


	# end

	# Approve- Program Unit or Payment Unit creation actions -start
	def approve_program_wizard_run_id

		lb_saved = true
		@client = Client.find(session[:CLIENT_ID])
		l_wizard_id = params[:program_wizard_id]
		program_unit_object = ProgramUnit.find(params[:program_unit_id].to_i)
		program_wizard_object = ProgramWizard.find(l_wizard_id)
		ls_service_program = ServiceProgram.service_program_description(program_unit_object.service_program_id)
		# ret_hash = ProgramUnit.can_activate_program_unit?(program_wizard_object.run_id,program_wizard_object.month_sequence)
		# lb_boolean = ret_hash[:can_activate]
		# if lb_boolean
		begin
			ActiveRecord::Base.transaction do
				if program_unit_object.service_program_id == 3
					# TEA Diversion
					program_benefit_detail_collection = ProgramBenefitDetail.where("run_id = ? and month_sequence = ?",program_wizard_object.run_id,program_wizard_object.month_sequence)
					program_benefit_detail = program_benefit_detail_collection.first
					msg = ProgramUnit.approve_tea_diversion_program_unit(program_unit_object.id,l_wizard_id,program_benefit_detail.reimbursed_amount)
				else
					if program_unit_object.service_program_id == 1 || program_unit_object.service_program_id == 4
						# TEA & Work pays
						msg = ProgramUnit.approve_program_unit(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
					end
				end

				if msg == "SUCCESS"
					# step1 : Populate common event management argument structure
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.event_id = 736 # "Request to Approve Program Unit is Approved"
			        common_action_argument_object.program_wizard_id = program_wizard_object.id
			        common_action_argument_object.program_unit_id = program_unit_object.id
			        common_action_argument_object.client_id = @client.id

			        # Queue related settings
			        common_action_argument_object.queue_reference_type = 6345
			        common_action_argument_object.queue_reference_id = program_unit_object.id

			        # step2: call common method to process event.

			        ls_msg = EventManagementService.process_event(common_action_argument_object)
			        if ls_msg == "SUCCESS"
			        	lb_saved = program_unit_object.approve
						unless lb_saved
							ls_msg = program_unit_object.errors.full_messages.last
						end
					else
						lb_saved = false
					end
			  	end
		  	end
	  	rescue => err
	  		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","approve_program_wizard_run_id",err,AuditModule.get_current_user.uid)
	  		lb_saved = false
	  		ls_msg = "Failed to activate program unit - for more details refer to error ID: #{error_object.id}."
  		end

		if lb_saved
			flash[:notice] = "Program unit activated successfully."
			# redirect_to index_eligibility_determination_runs_path(params[:program_unit_id].to_i)
			redirect_to alerts_path
		else
			flash[:alert] = ls_msg
			redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","approve_program_wizard_run_id",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when activating program unit."
		redirect_to_back
	end
		# Approve- Program Unit or Payment Unit creation actions -End

	def edit_rejection_of_program_unit
		# First Time Benefit REjection Action.
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_wizard_object = ProgramWizard.find(params[:program_wizard_id].to_i)

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","edit_rejection_of_program_unit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when denying program unit."
		redirect_to_back

	end

	def update_rejection_of_program_unit

		lb_saved = true
		@client = Client.find(session[:CLIENT_ID])
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
		@program_wizard_object = ProgramWizard.find(params[:program_wizard_id].to_i)
		l_params = program_unit_rejection_params

		if l_params[:reason].present?
			@selected_program_unit.reason = l_params[:reason]

			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
			common_action_argument_object.event_id = 737 # "Request to Approve Program Unit is Rejected"
			common_action_argument_object.program_wizard_id = @program_wizard_object.id
	        common_action_argument_object.client_id = @client.id
	        common_action_argument_object.reason = @selected_program_unit.reason
	        common_action_argument_object.program_unit_id = @selected_program_unit.id
	        # task should be assigned to ED worker to work on the rejected TEA diversion
	        common_action_argument_object.user_id = @selected_program_unit.eligibility_worker_id

	        # queue related settings
	        common_action_argument_object.queue_reference_type = 6345
			common_action_argument_object.queue_reference_id = @selected_program_unit.id

	        begin
  				ActiveRecord::Base.transaction do
  					lb_saved = @selected_program_unit.reject
  					if lb_saved == false
  						ls_msg = @selected_program_unit.errors.full_messages.last
  						Rails.logger.debug("rejection - failed - #{ls_msg}")
  						raise "error"
  					end
  					Rails.logger.debug("rejection - successful")

  					# step2: call common method to process event.
			        ls_msg = EventManagementService.process_event(common_action_argument_object)
			        if ls_msg == "SUCCESS"
			        	Rails.logger.debug("rejection -EventManagementService-  successful")
					#mANOJ 04/21/2016 - THE REJECTED SUPERVISOR WILL BE WORKING ON THIS AGAIN - HENCE COMMENTED BELOW CODE.
		      #   		program_unit_task_owner= ProgramUnitTaskOwner.get_program_unit_task_owner(@selected_program_unit.id,6620)
					  	# if program_unit_task_owner.present?
					  	# 	program_unit_task_owner.destroy!
					  	# end
			        else
			        	Rails.logger.debug("rejection -EventManagementService-  failed")
			        	lb_saved = false
			        end


			  	end
		  	 rescue => err
		  	 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","update_rejection_of_program_unit",err,AuditModule.get_current_user.uid)
		  	 	lb_saved = false
		  	 	ls_msg = "Failed to reject program unit - for more details refer to error ID: #{error_object.id}."
	        end

			if lb_saved
				flash[:notice] = "Program unit rejected."
				# redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
				redirect_to alerts_path
			else
				flash[:alert] = ls_msg
				render 'edit_rejection_of_program_unit'
			end
	    else
	    	@selected_program_unit.errors[:reason] = "is required."
			render :edit_rejection_of_program_unit
	    end

	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","update_rejection_of_program_unit",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when rejecting program unit."
	 	redirect_to_back
	end



	def ready_for_assessment
		# used to flag - This Run id will be used for Planning.
		# Eligibility determination worker is done with his task and he requests to assign case manager to this PGU
			# create a work task to processing office of the program unit.
			li_program_unit_id =params[:program_unit_id].to_i
			program_unit_object = ProgramUnit.find(li_program_unit_id)
			@client = Client.find(session[:CLIENT_ID])

			l_wizard_id = params[:program_wizard_id]
			program_wizard_object = ProgramWizard.find(l_wizard_id)

			program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(program_wizard_object.run_id,program_wizard_object.month_sequence)
		    if program_month_summary_collection.present?
		        program_month_summary_object = program_month_summary_collection.first
		        if program_month_summary_object.budget_eligible_ind == "Y"
		            lb_proceed = true
		            error_msg = ""
		        else
		           lb_proceed = false
		           error_msg = "This program unit cannot be assessed because, client is not eligible for benefits."
		        end
		    else
		         lb_proceed = false
		         error_msg = "This program unit cannot be assessed because, client is not eligible for benefits."
		    end

		    # ED month should be current month check - no retro.
		    #   if  lb_proceed == true
		    #     ldt_run_month = program_wizard_object.run_month - 2.months
		    #     ldt_current_month = Date.today.strftime("01/%m/%Y").to_date
		    #     if ldt_run_month < ldt_current_month
					 # lb_proceed = false
		    #     	 error_msg = "You are submitting retro month payment, Payment month should be current month"
		    #     end
		    #   end

			if lb_proceed == true
				# Sync benefit member status to pgu members.
				ProgramUnit.sync_program_unit_member_status_with_benefit_member_status(program_unit_object.id,program_wizard_object.id)
	          	# update case type of program wizard and sync it to program unit case type
	        	ProgramWizard.update_case_type(program_wizard_object.id)
				# Rule 1- select this run for planning.
				# 1.program_wizards.selected_for_planning = 'Y'
				# 2.program_units.eligible_for_planning = 'Y'
				# 3.event to action - complete Task (ED complete) & Move PGU to Assessment Queue
				#
			 	#  create work task to processing office to Approve the benefit amount.
			 	# self_of_pgu_collection = ProgramUnitMember.get_primary_beneficiary(program_unit_object.id)
     #    		self_of_pgu_object = self_of_pgu_collection.first
     			primary_contact = PrimaryContact.get_primary_contact(program_unit_object.id, 6345)
        		client_object = Client.find(primary_contact.client_id)
			 	# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.event_id = 684 # "Eligible for Planning event"
		        common_action_argument_object.program_unit_id = program_unit_object.id
		        common_action_argument_object.client_id = client_object.id

		        # Queue related variables.
		        common_action_argument_object.queue_reference_type = 6345 # program unit
            	common_action_argument_object.queue_reference_id = program_unit_object.id

			 	begin
					ActiveRecord::Base.transaction do
						ls_msg = ProgramWizard.mark_this_run_id_for_planning(program_wizard_object.id)
						if ls_msg == "SUCCESS"
							# Close work on the PGU Task assigned to Eligibility worker- since he finished ED for PGU.
							# WorkTask.complete_work_task_for_program_unit(program_wizard_object.program_unit_id,6346)
							 # step2: call common method to process event.
				        	ls_msg = EventManagementService.process_event(common_action_argument_object)
				        	if ls_msg == "SUCCESS"
				        		program_unit_object.request
				    #     		ls_processing_office = CodetableItem.get_short_description(program_unit_object.processing_location)
								# flash[:notice] = "Request to Assign Case Manager to the program unit is assigned to processing Local Office:#{ls_processing_office}, Supervisor will assign Case Manager to the Program Unit."

								flash[:notice] = "Eligibility determination completed for this program unit."
				        	else
				        		flash[:alert] = ls_msg
				        	end
						else
							flash[:alert] = ls_msg
						end
					end
				rescue => err
			  		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","ready_for_assessment",err,AuditModule.get_current_user.uid)
			  		ls_msg = "Failed to process ready for assessment - for more details refer to error ID: #{error_object.id}."
			  		flash[:alert] = ls_msg
		        end
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
			else
				flash[:alert] = error_msg
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
			end
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","ready_for_assessment",err,current_user.uid)
			flash[:alert] = "Error occurred in method ready_for_assessment for more details refer to error ID: #{error_object.id}."
			redirect_to_back
	end


	def continue_assessment
			ls_msg = nil
			error_msg = nil
			# If ED worker also does case management - he can continue and become case manager for the PGU.
			# create a work task to processing office of the program unit.
			li_program_unit_id =params[:program_unit_id].to_i
			program_unit_object = ProgramUnit.find(li_program_unit_id)
			@client = Client.find(session[:CLIENT_ID])

			l_wizard_id = params[:program_wizard_id]
			program_wizard_object = ProgramWizard.find(l_wizard_id)

			program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(program_wizard_object.run_id,program_wizard_object.month_sequence)
		    if program_month_summary_collection.present?
		        program_month_summary_object = program_month_summary_collection.first
		        if program_month_summary_object.budget_eligible_ind == "Y"
		            lb_proceed = true
		            error_msg = ""
		        else
		           lb_proceed = false
		           error_msg = "This program unit cannot be assessed because, client is not eligible for benefits."
		        end
		    else
		         lb_proceed = false
		         error_msg = "This program unit cannot be assessed because, client is not eligible for benefits."
		    end


			if lb_proceed == true
				# Rule 1- select this run for planning.
				# 1.program_wizards.selected_for_planning = 'Y'
				# 2.program_units.eligible_for_planning = 'Y'
				# 3.become case manager to case.
				#
			 	#  create work task to processing office to Approve the benefit amount.
			 	self_of_pgu_collection = PrimaryContact.get_primary_contact(program_unit_object.id, 6345)
			 	# self_of_pgu_collection = ProgramUnitMember.get_primary_beneficiary(program_unit_object.id)
        		self_of_pgu_object = self_of_pgu_collection.first
        		program_unit_object.case_manager_id = current_user.uid
			 	# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        # common_action_argument_object.event_id = 6500 # "Eligible for Planning event"
		        # common_action_argument_object.program_unit_id = program_unit_object.id
		        common_action_argument_object.client_id = self_of_pgu_object.client_id
		        common_action_argument_object.model_object = program_unit_object
		        common_action_argument_object.changed_attributes = program_unit_object.changed_attributes().keys
			 	begin
					ActiveRecord::Base.transaction do
						# ls_msg = ProgramWizard.mark_this_run_id_for_planning_and_continue_assessment(program_wizard_object.id)
						ls_msg = EventManagementService.process_event(common_action_argument_object)
						if ls_msg == "SUCCESS"
							# Close work on the PGU Task assigned to Eligibility worker- since he finished ED for PGU.
							# WorkTask.complete_work_task_for_program_unit(program_wizard_object.program_unit_id,6346)
							# redirect to CPP to proceed with CPP/assessment
							# step2
							ls_msg = ProgramWizard.mark_this_run_id_for_planning_and_continue_assessment(program_wizard_object.id)
							if ls_msg == "SUCCESS"
								assessment_collection = ClientAssessment.get_client_assessments(@client.id)
								if assessment_collection.present?
									@assessment_id = assessment_collection.first.id
								else
									@assessment_id = 0
								end
								flash[:notice] = "Run id is selected for planning."
								if program_unit_object.service_program_id == 1 || program_unit_object.service_program_id == 4
									redirect_to manage_cpp_path(@assessment_id)
								else
									if program_unit_object.service_program_id == 3
										redirect_to edit_common_assessment_path(14,@assessment_id)
									end
								end
							else
								flash[:alert] = ls_msg
								redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
							end
						else
							flash[:alert] = ls_msg
							redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
						end
					end
				rescue => err
						error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","contiue_assessment",err,current_user.uid)
						flash[:alert] = "Error occurred in method continue assessment for more details refer to error ID: #{error_object.id}."
						redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
				end
			else
				flash[:alert] = error_msg
				redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
			end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","ready_for_assessment",err,current_user.uid)
			flash[:alert] = "Error occurred in method ready_for_assessment for more details refer to error ID: #{error_object.id}."
			redirect_to_back
	end


	def select_this_run_for_planning
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		l_wizard_id = params[:program_wizard_id]
		@selected_program_wizard = ProgramWizard.find(l_wizard_id)
		ProgramWizard.update_selected_for_planning_flag_for_program_wizard(l_wizard_id)
		# flash[:notice] = "This Run ID is selected for planning"
		# redirect_to show_program_wizard_run_id_details_path(params[:program_unit_id].to_i,params[:program_wizard_id].to_i)
		redirect_to alerts_path,notice: "This run ID is selected for planning."
	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","select_this_run_for_planning",err,current_user.uid)
			flash[:alert] = "Error occurred in method select_this_run_for_planning for more details refer to error ID: #{error_object.id}."
			redirect_to_back
	end

	def by_pass_program_wizard
		ProgramWizardService.by_pass_program_wizard_and_run_ed(session[:PROGRAM_UNIT_ID])
		redirect_to program_units_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProgramWizardsController","by_pass_program_wizard",err,current_user.uid)
		flash[:alert] = "Error occurred in method by_pass_program_wizard for more details refer to error ID: #{error_object.id}."
		redirect_to_back
	end

private

		def set_benefit_member_data_for_add(arg_object,arg_params,arg_program_wizard_id)
			arg_object.program_wizard_id = arg_program_wizard_id
			arg_object.run_id = @program_wizard.run_id
			arg_object.month_sequence = @program_wizard.month_sequence
			arg_object.client_id = arg_params[:client_id]
			arg_object.member_status = arg_params[:member_status]
			arg_object.member_sequence = ProgramBenefitMember.get_next_member_sequence(arg_program_wizard_id)
			return arg_object
		end


  	 	def benefit_member_params
  	 		params.require(:program_benefit_member).permit(:client_id,:member_status)
  	 	end

  	 	def program_wizard_params
			# params.require(:program_wizard).permit(:run_month)
			run_month = params.require(:program_wizard).permit(:run_month)
			if run_month["run_month(1i)"].present? && run_month["run_month(1i)"].present? && run_month["run_month(1i)"].present?
				run_month = Date.new run_month["run_month(1i)"].to_i, run_month["run_month(2i)"].to_i, run_month["run_month(3i)"].to_i
			end
  	 	end

  	 	def tea_diversion_params
			params.require(:program_benefit_detail).permit(:reimbursed_amount)
  	 	end

  	 	def program_unit_rejection_params
  	 		params.require(:program_unit).permit(:reason)
  	 	end


  	 	def details_for_run_id(arg_program_unit_id,arg_program_wizard_id)
  	 		#  called from summary show link and Approve show link
			@client = Client.find(session[:CLIENT_ID])
			# Details for each Run ID.
			@selected_program_unit= ProgramUnit.find(arg_program_unit_id)
			@selected_program_wizard = ProgramWizard.find(arg_program_wizard_id)
			# @program_wizard_benefit_members = @selected_program_wizard.program_benefit_members
			@program_wizard_benefit_members = ProgramBenefitMember.get_program_benefit_members(@selected_program_wizard.run_id)
			@program_month_summary_collection = ProgramMonthSummary.get_program_month_summary_collection(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
			@program_benefit_detail = ProgramBenefitDetail.get_program_benefit_detail_collection(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
			@program_members_summaries = ProgramMemberSummary.get_program_member_summary_collection(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
			@eligibility_deterimine_results = EligibilityDetermineResult.get_results_list(@selected_program_wizard.run_id,@selected_program_wizard.month_sequence)
			if @program_month_summary_collection.present?
				program_month_summary_object = @program_month_summary_collection.first
				if program_month_summary_object.budget_eligible_ind == "Y"
					@eligible_indicator = "Y"
				else
					@eligible_indicator = "N"
				end
			else
				@eligible_indicator = "N"
			end

  	 	end

  # 	 	def get_program_benefit_members_list(arg_program_wizard_id)
  # 	 		# Manoj Patil -02/07/2015
  # 	 		# Description : Instance variables Used in Second step - select program benefit members view.

  # 	 		# 1. For Grou check box
  # 	 		# All records = program unit members for given program unit ID
  # 	 		#  Checked records = program benefit members for the given program wizard id
		# 	@program_unit_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_program_wizard_id)
		# 	@program_unit_benefit_members_array = []
		# 	if @program_unit_benefit_members.present?
		# 		@program_unit_benefit_members.each do |each_member|
		# 			@program_unit_benefit_members_array << each_member.client_id
		# 		end
		# 	end

		# 	# 2. Program benefit members status dropdown

		# 	# items_include = [4468,4469,4470,4471]
		# 	# @program_unit_member_status = CodetableItem.items_to_include(84,items_include," benefit member status")
		# 	@program_unit_member_status = CodetableItem.get_code_table_values_by_system_params((@selected_program_unit.service_program_id).to_s)

		# 	# select_tag("benefit_member_status[]", options_for_select([
		# 	# 					                                      ['dusplay value', data value],
		# 	# 				                                          ['Co', 2],
		# 	# 				                                          ['Bought', 3],
		# 	# 				                                          ['View', 4],
		# 	# 				                                          ['Top API', 5]
		# 	# 			                                          ],
		# 	# 			                                          selected: get_benefit_member_status(@program_wizard.id,arg_member.client_id)
		# 	# 			                                          )

		# 	# options_for_select first argument needs Array of arrays.
		# 	#
		# 	@program_unit_member_status_drop_down_array = []


		# 	@program_unit_member_status.each do |each_object|
		# 		l_elemnt_array = []
		# 		l_elemnt_array << each_object.short_description
		# 		l_elemnt_array << each_object.id
		# 		@program_unit_member_status_drop_down_array << l_elemnt_array
		# 	end
		# end

		def objects_required_for_eligibility_determination_wizard(arg_program_unit_id)
			#  similar to EDit REST action
			# Multi step form - wizard
			@client = Client.find(session[:CLIENT_ID])
			@selected_program_unit = ProgramUnit.find(arg_program_unit_id)
			@program_wizard = ProgramWizard.find(session[:NEW_PROGRAM_WIZARD_ID].to_i)
			if @program_wizard.run_month.present?
				formated_run_month = @program_wizard.run_month.strftime("%m/%Y")
				@run_month_description = "for month: #{formated_run_month}"
			else
				@run_month_description = " "
			end
			 #  which step object to be shown on the start_check_program_eligibility_wizard.html.erb
	      	@program_wizard.current_step = session[:PROGRAM_WIZARD_STEP]
			if session[:PRIMARY_BENEFICIARY].present?
				session[:CLIENT_ID] = session[:PRIMARY_BENEFICIARY]
				session[:PRIMARY_BENEFICIARY] = nil
			end
	  		if session[:PROGRAM_WIZARD_STEP] == "program_wizard_first" || @program_wizard.current_step == "program_wizard_first"
	  			# step 1 - Select Eligibility Determination Month
	  		elsif session[:PROGRAM_WIZARD_STEP] == "program_wizard_second"
	  			#  step 2 - Select Program Unit Members.
	  			@program_unit_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_and_client_details_from_wizard_id(@program_wizard.id)
	   		elsif session[:PROGRAM_WIZARD_STEP] == "program_wizard_last"

	  			# Last Step Resource page with FINISH Button.
	  			@program_benefit_members = ProgramBenefitMember.get_program_benefit_members(@program_wizard.run_id)#@program_wizard.program_benefit_members
	  			@benefit_members_incomes = ClientIncome.get_benefit_members_incomes(@program_wizard.id,@program_wizard.run_month)
	  			@benefit_members_expenses = ClientExpense.get_benefit_members_expenses(@program_wizard.id,@program_wizard.run_month)
	  			@benefit_members_resources = ClientResource.get_benefit_members_resources(@program_wizard.id,@program_wizard.run_month)
	 		end
		end



end

