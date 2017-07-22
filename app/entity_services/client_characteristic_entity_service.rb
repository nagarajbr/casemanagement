class ClientCharacteristicEntityService

	def self.eligibility_determination(arg_object,arg_event_to_action_mapping_object)
		# if arg_object.model_object.characteristic_type == "WorkCharacteristic" || arg_object.model_object.characteristic_type == "LegalCharacteristic"
		# if ["WorkCharacteristic","LegalCharacteristic","OtherCharacteristic"].include?(arg_object.model_object.characteristic_type)
		# 	can_create_an_ed_entry = true
		# 	if arg_object.model_object.characteristic_type == "LegalCharacteristic"
		# 		ed_reason = 6533
		# 		if arg_event_to_action_mapping_object.event_type == 771
		# 			can_create_an_ed_entry = false
		# 		end
		# 	end
		# 	if arg_object.model_object.characteristic_type == "OtherCharacteristic"
		# 		ed_reason = 6534
		# 		can_create_an_ed_entry = false
		# 		# create an entry for ED for other characteristic type is either "Family Cap" or "No School Attendance"
		# 		if arg_object.model_object.characteristic_id.to_i == 5610 || arg_object.model_object.characteristic_id.to_i == 6541
		# 			if arg_object.model_object.is_a_new_record
		# 				can_create_an_ed_entry = true
		# 			elsif arg_event_to_action_mapping_object.event_type == 770 # In case of edit the start date change should only trigger an ed entry
		# 				can_create_an_ed_entry = true
		# 			end
		# 		end
		# 	end
		# 	if can_create_an_ed_entry && ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_object.client_id) &&
		# 											ProgramUnitMember.is_the_client_active_in_any_program_unit(arg_object.client_id)
		# 		program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
		# 		CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6532) # 6526 - "Eligibility Determination"
		# 	end
		# end

		can_create_an_ed_entry = true
		ed_reason = nil
		case arg_object.model_object.characteristic_type
		when "WorkCharacteristic"
			ed_reason = 6532 # "Work Participation Characteristic Changed"
		when "LegalCharacteristic"
			# ed_reason = 6533 # "Legal Characteristic Changed"
			# if arg_event_to_action_mapping_object.event_type == 771
				# can_create_an_ed_entry = false
			# else
				case arg_object.model_object.characteristic_id
				when 5611 # "Felony Drug Conviction"
					ed_reason = 6596 # "Drug conviction Information Changed"
				when 5612 # "Fleeing Felon"
					ed_reason = 6595 # "Fleeing Felon Information Changed"
				when 5614,5631,5632 # "IPV"
					ed_reason = 6594 # "IPV Information Changed"
				when 5616 # "Gang Activity"
					ed_reason = 6597 # "Gang activity Information Changed"
				end
			# end
		when "OtherCharacteristic"
			ed_reason = nil
			# create an entry for ED for other characteristic type is either "Family Cap" or "No School Attendance"
			if arg_object.model_object.characteristic_id.to_i == 5610 # "Family Cap Child"
				ed_reason = 6534 # "Other Characteristic Family Cap Information Changed"
			elsif arg_object.model_object.characteristic_id.to_i == 6541 # "No school attendance"
				ed_reason = 6583 # "Other Characteristic No School Attendance Information Changed"
			end
			can_create_an_ed_entry = false
			if ed_reason.present?
				can_create_an_ed_entry = true
				# if arg_object.is_a_new_record
				# 	can_create_an_ed_entry = true
				# elsif arg_event_to_action_mapping_object.event_type == 770 || arg_event_to_action_mapping_object.event_type == 769# In case of edit the start date change should only trigger an ed entry
				# 	can_create_an_ed_entry = true
				# end
			end
		when "DisabilityCharacteristic"
			can_create_an_ed_entry = false
		end
		if can_create_an_ed_entry && ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_object.client_id)
			program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_object.client_id)
			date = arg_object.run_month.beginning_of_month
			number_of_months = (arg_object.run_month.year * 12 + arg_object.run_month.month) - (Date.today.year * 12 + Date.today.month)
			if (arg_object.run_month < Date.today || number_of_months == 0)
				date = Date.today
			end
			CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526, ed_reason, arg_object.client_id,date,'N') # 6526 - "Eligibility Determination"
		end
	end

end