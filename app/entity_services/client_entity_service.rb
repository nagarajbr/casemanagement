class ClientEntityService
	def self.ssn_enumeration(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6512,nil,nil,nil,'N') # 6512 - "SSN Enumeration"
		end
	end

	def self.citizenship_verification(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6513,nil,nil,nil,'N') # 6513 - "Citizenship"
		end
	end

	def self.ocse_referral(arg_object,arg_event_to_action_mapping_object)
		reason = nil
		if arg_object.address_type.blank? # || (arg_object.address_type.present? && arg_object.address_type == 4665) # "Mailing Address"
			if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id) &&
							AgencyReferral.is_the_client_previously_referred_to_ocse(arg_object.client_id)
					CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6514,6569,nil,nil,'N') # 6514 - "OCSE"
					if ClientParentalRspability.is_an_absent_parent_of_an_active_child_in_program_unit(arg_object.client_id)
						CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6514,6554,nil,nil,'N') # 6514 - "OCSE"
					end

					# if ClientParentalRspability.is_an_absent_parent_of_an_active_child_in_program_unit(arg_object.client_id)
					# 	reason = 6554 # "Absent Parent Information Changed"
					# else
					# 	reason = 6569 # "Client Information Changed"
					# end
			elsif ClientParentalRspability.is_an_absent_parent_of_an_active_child_in_program_unit(arg_object.client_id)
				reason = 6554 # "Absent Parent Information Changed"
			end
		elsif arg_object.address_type == 4665 && arg_object.entity_type == 6150 # "Mailing Address"
			reason = 6569
		end
		if reason.present?
			CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6514,reason,nil,nil,'N') # 6514 - "OCSE"
		end
	end

	def self.ebt(arg_object,arg_event_to_action_mapping_object)
		if arg_object.address_type.blank? || ((arg_object.address_type.present? && arg_object.address_type == 4665) && (arg_object.entity_type == 6150)) # "Mailing Address"
			if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_object.client_id) &&
									ProgramUnitRepresentative.is_representative_of_an_open_program_unit(arg_object.client_id)
				CommonEntityService.create_batch_process_entry_if_needed(6150, arg_object.client_id, 6515,nil,nil,nil,'N') # 6515 - "EBT"
			end
		end
	end

	def self.eligibility_determination(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6546,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination", 6546 - "Date of Birth Information Changed"
		end
	end

	def self.living_arrangement(arg_object,arg_event_to_action_mapping_object)
		if arg_object.address_type.present? && arg_object.address_type == 4664  && arg_object.entity_type == 6150# "Non Mailing Address"
			if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
				program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
				CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6531,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination", 6531 - "ED Reason Living Arrangement"
			end
		end
	end

	def self.immunization(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6535,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination", 6535 - "ED "Immunization Information Changed""
		end
	end

	def self.out_of_state_payments(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6538,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination", 6538 - "Out of state payment information changed"
		end
	end

	def self.income(arg_object,arg_event_to_action_mapping_object)
		if IncomeDetail.get_income_detail_by_income_id(arg_object.model_object.id).present?
			unless arg_object.is_a_new_record == true
				if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
					program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
					CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6542,arg_object.client_id,nil,'N') # 6526 - "Eligibility Determination", 6542 - "Income Information Changed",arg_object.client_id
				end
			end
		end
	end

	def self.education(arg_object,arg_event_to_action_mapping_object)
		client_age = Client.get_age(arg_object.client_id)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id) && client_age > 0 && client_age < SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6536,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6536 - "Education Information Changed"
		end
	end


	def self.income_details(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6543,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6543 - "Income Detail Information Changed"
		end
	end


	def self.employment(arg_object,arg_event_to_action_mapping_object)
		client_age = Client.get_age(arg_object.client_id)
		if ProgramUnitMember.is_the_client_active_in_work_pays_program_unit(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_work_pays_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6537,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6536 - "Employment Information Changed"
		end
	end

	def self.income_detail_adjust_reasons(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6544,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6536 - "Employment Information Changed"
		end
	end

	def self.parental_rspabilities_ocse_referral(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			reason = nil
			case arg_object.event_id
			when 804 # "parent_status"
				if arg_object.model_object.parent_status == 6076
					reason = 6551
				end
			when 805 # "good_cause"
				unless arg_object.is_a_new_record
					reason = 6552
				end
			when 806 # "deprivation_code"
				unless arg_object.is_a_new_record
					reason = 6553
				end
			when 807,808,809 # 807 - "court_ordered_amount", 808 - "amount_collected", 809 - "court_order_number"
				unless arg_object.is_a_new_record
					reason = 6554
				end
			end
			if reason.present?
				program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
				CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6514,reason,arg_object.client_id,nil,'N') # 6514 - "OCSE"
			end
		end
	end

	def self.resource(arg_object,arg_event_to_action_mapping_object)
		if arg_object.is_a_new_record == false
			if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
				program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
				CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6547,arg_object.client_id,nil,'N') # 6526 - "Eligibility Determination", 6547 - "Resource Information Changed"
			end
		end
	end

	def self.resource_detail(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6548,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6548 - "Resource Detail Information Changed"
		end
	end

	def self.resource_adjustment(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6549,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6549 - "Resource Adjustment Information Changed"
		end
	end

	def self.resource_use(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6550,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6550 - "Resource Use Information Changed"
		end
	end

	def self.citizenship_verification_for_citizenship_info_change(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6518,6577,arg_object.client_id,nil,'N') # 6518 - "Citizenship Verification", 6577 - "Citizenship Information Changed"
		end
	end

	def self.ed_entry_for_citizenship_info_change(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6577,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination" , 6577 - "Citizenship Information Changed"
		end
	end

	def self.ed_entry_for_non_citizenship_info_change(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6578,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination" , 6578 - "Non citizenship Information Changed"
		end
	end

	def self.ed_entry_for_residency_info_change(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6584,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination", 6584 - "Residency Information Changed"
		end
	end

	def self.ocse_referral_on_cancel_pymt(arg_object,arg_event_to_action_mapping_object)
		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6514,6588,arg_object.client_id,nil,'N') # 6514 - "OCSE", 6588 - "Payment cancelled"
	end

	def self.ebt_on_cancel_pymt(arg_object,arg_event_to_action_mapping_object)
		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6515,nil,nil,nil,'N') # 6515 - "EBT"
	end

	def self.notice_for_rejecting_an_aplication(arg_object,arg_event_to_action_mapping_object)
		if arg_object.selected_app_action.present? && arg_object.selected_app_action == 6018
			notice_generation_obj = NoticeGeneration.new
			notice_generation_obj.notice_generated_date = Date.today
			notice_generation_obj.action_type = arg_object.selected_app_action # "Changed"
			notice_generation_obj.action_reason = arg_object.app_action_reason
			notice_generation_obj.date_to_print = Date.today
			notice_generation_obj.notice_status = 6614 # "Pending"
			notice_generation_obj.reference_type = 6587
			notice_generation_obj.reference_id = arg_object.client_application_id
			client_application_object = ClientApplication.find(arg_object.client_application_id)
			if client_application_object.present?
				notice_generation_obj.processing_location = client_application_object.application_received_office
				notice_generation_obj.case_manager_id = client_application_object.intake_worker_id
			end
			notice_generation_obj.save!
		end
	end

	def self.ebt_on_adding_a_representative(arg_object,arg_event_to_action_mapping_object)
		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6515,6589,arg_object.client_id,nil,'N') # 6515 - "EBT", 6589 - "Adding Program Unit representative"
	end

	def self.ebt_on_deactivating_a_representative(arg_object,arg_event_to_action_mapping_object)
		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6515,6590,arg_object.client_id,nil,'N') # 6515 - "EBT", 6590 - "Deactivating Program Unit representative"
	end

	def self.ed_entry_for_relationship(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6585,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination" , 6585 - "Relationship Information Changed"
		end
	end

	def self.ed_entry_for_sanctions(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			case arg_object.sanction_type
			when 3081 # "Immunizations"
				ed_reason = 6598 # "Immunizations Sanction"
			when 3062 # "OCSE Non-Compliance"
				ed_reason = 6599 # "OCSE Sanction"
			when 3064,3067,3068,3070,3073,3085 # Progressive Sanction
				ed_reason = 6600 # "Progressive Sanction"
			when 6349 # "Refusal to sign PRA by minor parent"
				ed_reason = 6601 # "Refusal to sign PRA by minor parent"
			when 6225 # #Class Attendance-Minor Parent
				ed_reason = 6602 # "Class attendance-minor parent"
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,ed_reason,arg_object.client_id,nil,'N') # 6526 - "Eligibility Determination"
		end
	end

	def self.ed_entry_for_sanction_detail(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id) &&
							(arg_object.is_a_new_record || arg_object.model_object.release_indicatior == '1')
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			case arg_object.sanction_type
			when 3081 # "Immunizations"
				ed_reason = 6598 # "Immunizations Sanction"
			when 3062 # "OCSE Non-Compliance"
				ed_reason = 6599 # "OCSE Sanction"
			when 3064,3067,3068,3070,3073,3085 # Progressive Sanction
				ed_reason = 6600 # "Progressive Sanction"
			when 6349 # "Refusal to sign PRA by minor parent"
				ed_reason = 6601 # "Refusal to sign PRA by minor parent"
			when 6225 # #Class Attendance-Minor Parent
				ed_reason = 6602 # "Class attendance-minor parent"
			end
			date = nil
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,ed_reason,arg_object.client_id,date,'Y') # 6526 - "Eligibility Determination"
		end
	end

	def self.ed_entry_for_client_death_date_info(arg_object,arg_event_to_action_mapping_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6608,arg_object.client_id,Date.today,'N') # 6526 - "Eligibility Determination", 6608 - "Client Date of Death Entered"
		end
	end

	def self.ed_entry_for_employment_detail_info_change(arg_object,arg_event_to_action_mapping_object)
		client_active_adult_in_workpays = ProgramUnitMember.is_the_client_adult_and_active_in_work_pays_program_unit(arg_object.client_id)
		if client_active_adult_in_workpays.present?
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6609,arg_object.client_id,date,'N') # 6526 - "Eligibility Determination", 6609 - "Employment Detail Information Changed"
		end
	end

	def self.work_pays_entry_for_activity_hours_info_change(arg_object,arg_event_to_action_mapping_object)
		CommonEntityService.create_batch_process_entry_if_needed(6524, arg_object.program_unit_id, 6611,nil,arg_object.client_id,nil,'N') # 6526 - "Eligibility Determination", 6608 - "Client Date of Death Entered"
	end
end