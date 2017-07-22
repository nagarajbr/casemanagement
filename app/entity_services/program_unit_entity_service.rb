class ProgramUnitEntityService
	def self.program_unit_submit(arg_object,arg_event_to_action_mapping_object)
		# if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit = ProgramUnit.get_program_unit_form_program_wizard_id(arg_object.program_wizard_id)
			notice_generation_obj = NoticeGeneration.get_notice_generation_record(program_unit.id,6345)
			if notice_generation_obj.blank?
				notice_generation_obj = NoticeGeneration.new
			end
			notice_generation_obj.notice_generated_date = Date.today
			notice_generation_obj.action_type = 6572 # "Changed"
			notice_generation_obj.action_reason = 0
			notice_generation_obj.date_to_print = Date.today
			notice_generation_obj.notice_status = 6614 # "Pending"
			notice_generation_obj.program_wizard_id = arg_object.program_wizard_id
			notice_generation_obj.reference_type = 6345 #program unit
			notice_generation_obj.reference_id = program_unit.id
			if program_unit.present?
				notice_generation_obj.processing_location = program_unit.processing_location
				notice_generation_obj.case_manager_id = program_unit.eligibility_worker_id
				notice_generation_obj.service_program_id = program_unit.service_program_id
			end
			notice_generation_obj.save!
		# end
	end

	def self.program_unit_closure(arg_object,arg_event_to_action_mapping_object)
		# fail
		# Two tasks handled as part of this method
		# 1. Program Unit Closure
		# 2. TEA bonus and transportation bonus if closure due to good reason

  		# insert record in program participation
  		msg = "SUCCESS"
  		if arg_object.selected_pgu_action ==  6100
  			program_unit_object = ProgramUnit.find(arg_object.program_unit_id)
	  		if program_unit_object.service_program_id == 1

	  			# Handle Bonus Payments
	  			lb_bonus_close_reason_present = SystemParam.tea_bonus_close_reason_present?(arg_object.pgu_action_reason)
	  			if arg_object.selected_pgu_action ==  6100 && lb_bonus_close_reason_present == true
	  				msg = ProgramUnitService.close_tea_program_with_good_reason(arg_object.program_unit_id,arg_object.pgu_action_date,arg_object.pgu_action_reason)
	  			else
	  				msg = ProgramUnitService.close_tanf_no_good_reason(arg_object.program_unit_id,arg_object.pgu_action_date,arg_object.pgu_action_reason)
	  			end
	  		else
	  			msg = ProgramUnitService.close_tanf_no_good_reason(arg_object.program_unit_id,arg_object.pgu_action_date,arg_object.pgu_action_reason)
	  			# msg = create_participation_record(arg_params,arg_object.program_unit_id,6044) # Close = 6044
	  			# msg = ProgramUnitService.close_tea_workpays_no_good_reason(arg_object.program_unit_id,arg_object.pgu_action_date,arg_object.pgu_action_reason)
	  		end
  		end
  		return msg
  	end

  	def self.close_all_associated_activities_on_program_unit_closure(arg_object,arg_event_to_action_mapping_object)
  		if arg_object.selected_pgu_action ==  6099 # Deny
  			action_plans = ActionPlan.get_all_open_action_plans_for_the_program_unit(arg_object.program_unit_id)
	  		action_plans.each do |action_plan|
	  			action_plan.end_date = Date.today
				action_plan.action_plan_status = 6044 # Close
				action_plan.outcome_code = 3095 # "System Closure"
				if action_plan.valid?
					action_plan.save!
					outcome = Outcome.new
					outcome.outcome_code = 3095 # "System Closure"
					# outcome.notes = l_params[:outcome_notes]
					outcome.reference_id = action_plan.id
					if  action_plan.action_plan_type == 2976
						outcome.outcome_entity = 6254 # Employment plan
					else
						outcome.outcome_entity = 6251 # Barrier Reduction Plan
					end
					outcome.save!
				end
	  		end
  		end
  	end

  	def self.notice_on_program_unit_closure(arg_object,arg_event_to_action_mapping_object)
  		if arg_object.selected_pgu_action ==  6100 || (arg_object.selected_pgu_action ==  6099 and arg_object.pgu_deny_notice_generation_flag == 'Y') # 6100 - close, 6099 - deny
  			notice_generation_obj = NoticeGeneration.new
			notice_generation_obj.notice_generated_date = arg_object.pgu_action_date
			notice_generation_obj.action_type = arg_object.selected_pgu_action
			notice_generation_obj.action_reason = arg_object.pgu_action_reason
			notice_generation_obj.date_to_print = arg_object.pgu_action_date
			notice_generation_obj.notice_status = 6614 #pending
			notice_generation_obj.reference_type = 6345 #program unit
			notice_generation_obj.reference_id = arg_object.program_unit_id
			program_unit = ProgramUnit.find(arg_object.program_unit_id)
			if program_unit.present?
				notice_generation_obj.processing_location = program_unit.processing_location
				notice_generation_obj.case_manager_id = program_unit.eligibility_worker_id
				notice_generation_obj.service_program_id = program_unit.service_program_id
			end
			notice_generation_obj.save!
  		end
  	end

  	def self.close_all_program_unit_representatives(arg_object,arg_event_to_action_mapping_object)
  		if arg_object.selected_pgu_action ==  6100 || arg_object.selected_pgu_action ==  6099 # 6100 - close, 6099 - deny
  			program_unit_representatives = ProgramUnitRepresentative.get_open_program_unit_representatives(arg_object.program_unit_id)
  			if program_unit_representatives.present?
  				program_unit_representatives.each do |pgur|
	  				pgur.end_date = Date.today
	  				pgur.save!
	  			end
	  			# program_unit_representatives.update_all(end_date: Date.today)
  			end
  		end
  	end

  	def self.ocse_closure_referral(arg_object,arg_event_to_action_mapping_object)
  		if AgencyReferral.is_the_client_previously_referred_to_ocse(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6514,6579,nil,nil,'N') # 6514 - "OCSE"
		end
  	end

  	def self.delete_pgu_pending_tasks(arg_object,arg_event_to_action_mapping_object)
  		WorkTask.delete_all_pending_work_tasks(arg_object.program_unit_id)
  	end

  	def self.first_time_pgu_activation_notice_to_self(arg_object,arg_event_to_action_mapping_object)
		notice_generation_obj = NoticeGeneration.new
		notice_generation_obj.notice_generated_date = Date.today
		notice_generation_obj.action_type = 6043 # "Open"
		notice_generation_obj.action_reason = 6042
		notice_generation_obj.date_to_print = Date.today
		notice_generation_obj.notice_status = 6614 # "Pending"
		notice_generation_obj.reference_id = arg_object.program_unit_id
		notice_generation_obj.reference_type = 6345
		program_unit = ProgramUnit.find(arg_object.program_unit_id)
		if program_unit.present?
			notice_generation_obj.processing_location = program_unit.processing_location
			notice_generation_obj.case_manager_id = program_unit.eligibility_worker_id
			notice_generation_obj.service_program_id = program_unit.service_program_id
		end
		notice_generation_obj.save!
  	end

  	def self.first_time_pgu_activation_ebt(arg_object,arg_event_to_action_mapping_object)
  		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6515,nil,nil,nil,'N') # 6515 - "EBT"
  	end

  	def self.first_time_pgu_activation_ssn_enumeration(arg_object,arg_event_to_action_mapping_object)
  		program_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_object.program_wizard_id)
  		program_benefit_members.each do |pbm|
  			client = Client.find(pbm.client_id)
  			if client.ssn_enumeration_type == 4352 || client.ssn_enumeration_type == 4353
  				CommonEntityService.create_batch_process_entry_if_needed(6150, client.id, 6512,nil,nil,nil,'N') # 6512 - "SSN Enumeration"
  			end
  		end
  	end

  	def self.first_time_pgu_activation_citizenship_verification(arg_object,arg_event_to_action_mapping_object)
  		program_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_object.program_wizard_id)
  		program_benefit_members.each do |pbm|
  			client = Client.find(pbm.client_id)
  			if client.sves_type = 4656
  				CommonEntityService.create_batch_process_entry_if_needed(6150, client.id, 6513,nil,nil,nil,'N') # 6513 - "Citizenship"
  			end
  		end
  	end

  	def self.first_time_pgu_activation_wage_and_ui(arg_object,arg_event_to_action_mapping_object)
  		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6581,nil,nil,nil,'N') # 6581 - "Wage and UI"
  	end

  	def self.first_time_pgu_activation_ocse_referral(arg_object,arg_event_to_action_mapping_object)
  		if ProgramUnit.is_there_an_absent_parent(arg_object.program_unit_id)
  			program_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_object.program_wizard_id)
	  		program_benefit_members.each do |pbm|
	  			client = Client.find(pbm.client_id)
	  			if client.sves_type == 4656
	  				CommonEntityService.create_batch_process_entry_if_needed(6150, client.id, 6514,nil,nil,nil,'N') # 6514 - "OCSE"
	  			end
	  		end
  		end
  	end

  	def self.first_time_pgu_member_deactivation(arg_object,arg_event_to_action_mapping_object)
  		run_month = ProgramWizard.find(arg_object.program_wizard_id).run_month
  		program_benefit_members = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_object.program_wizard_id)
  		program_benefit_members.each do |pbm|
  			if Client.child_turns_adult_in_a_given_month(pbm.client_id, run_month)
  				CommonEntityService.create_batch_process_entry_if_needed(6150, pbm.client_id, 6582,nil,nil,nil,'N') # 6582 - "Client Deactivate"
  			end
  		end
  	end

end