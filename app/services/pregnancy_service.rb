class PregnancyService
	def self.create_pregnancy(arg_pregnancy_object, arg_notes)
		begin
			ActiveRecord::Base.transaction do
				PregnancyService.trigger_events_for_pregnancy_attr_changes(arg_pregnancy_object)
				arg_pregnancy_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_pregnancy_object.client_id, # entity_id = Client id
	                                        6481,  # notes_type = pregnancy
	                                        arg_pregnancy_object.client_id, # reference_id = Client ID
	                                        arg_notes) # notes
	            end
			end
			msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Pregnancy-Model","create_pregnancy",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save pregnancy details - for more details refer to rrror ID: #{error_object.id}."
		end
	end
	def self.update_pregnancy(arg_pregnancy_object, arg_notes)
		begin
			ActiveRecord::Base.transaction do
				PregnancyService.trigger_events_for_pregnancy_attr_changes(arg_pregnancy_object)
				arg_pregnancy_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_pregnancy_object.client_id, # entity_id = Client id
	                                        6481,  # notes_type = pregnancy
	                                        arg_pregnancy_object.client_id, # reference_id = Client ID
	                                        arg_notes) # notes
	            else
	            	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            		NotesService.delete_notes(6150,arg_pregnancy_object.client_id,6481,arg_pregnancy_object.client_id)
	            end
			end
			msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Pregnancy-Model","update_pregnancy",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save pregnancy details - for more details refer to error ID: #{error_object.id}."
		end
	end

	def self.trigger_events_for_pregnancy_attr_changes(arg_pregnancy_object)
		ls_msg = nil
        	if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_pregnancy_object.client_id)
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
	            common_action_argument_object.client_id = arg_pregnancy_object.client_id
	            common_action_argument_object.model_object = arg_pregnancy_object
	            common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_pregnancy_object.client_id)
	            common_action_argument_object.changed_attributes = arg_pregnancy_object.changed_attributes().keys
	            common_action_argument_object.is_a_new_record = arg_pregnancy_object.new_record?
	            ls_msg = EventManagementService.process_event(common_action_argument_object)
			end
        return ls_msg
	end
end