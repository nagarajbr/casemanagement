class ProviderEntityService

	def self.aasis_verification(arg_object,arg_event_to_action_mapping_object)
		# fail
		if arg_object.address_type == 6151
			can_create_batch_entry = false
			if arg_object.event_id == 821
				if arg_object.model_object.status == 6155 # "status", 6155 - "Pending"
					can_create_batch_entry = true
				end
			else
				can_create_batch_entry = true
			end
			if can_create_batch_entry
				CommonEntityService.create_batch_process_entry_if_needed(6151, arg_object.provider_id, 6592,nil,nil,nil,'N') # 6592 - "ASSIS Verification"
			end
		end
	end

end