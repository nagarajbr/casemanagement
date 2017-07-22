class CommonEntityService
	def self.create_batch_process_entry_if_needed(arg_entity_type, arg_entity_id, arg_process_type, arg_reason, arg_client_id, arg_run_month, arg_submit_flag)
		# validation_result = true
		# if arg_conditional
		# 	# validation_result = ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_entity_id)
		# 	if arg_process_type == 6515 # "EBT" Check if client is primary or secondary reprentative in an open program unit
		# 		validation_result = validation_result && ProgramUnitRepresentative.is_representative_of_an_open_program_unit(arg_entity_id)
		# 	else # Check whether he is active in a program_unit
		# 		validation_result = validation_result && ProgramUnitMember.is_the_client_active_in_any_program_unit(arg_entity_id)
		# 		if arg_process_type == 6514 # "OCSE"
		# 			validation_result = validation_result && AgencyReferral.is_the_client_previously_referred_to_ocse(arg_entity_id)
		# 		elsif validation_result && arg_process_type == 6526
		# 			# Set entity id as program unit id since the entry into nightly batch table should go as ptogram_unit_id
		# 			arg_entity_id = ProgramUnit.get_open_program_unit_for_client(arg_entity_id)
		# 		end
		# 	end
		# end

		# if validation_result
			batch_process_obj = nil
			batch_process_entries = NightlyBatchProcess.get_batch_process_data(arg_entity_type, arg_entity_id, arg_process_type, arg_reason, arg_client_id, arg_run_month)
			if batch_process_entries.blank?
				batch_process_obj = NightlyBatchProcess.new
				batch_process_obj.entity_type = arg_entity_type
				batch_process_obj.entity_id = arg_entity_id
				batch_process_obj.process_type = arg_process_type
				batch_process_obj.reason = arg_reason if arg_reason.present?
				batch_process_obj.client_id = arg_client_id if arg_client_id.present?
				batch_process_obj.run_month = arg_run_month if arg_run_month.present?
				batch_process_obj.submit_flag = arg_submit_flag
				batch_process_obj.save!
			end
		# end
	end
end