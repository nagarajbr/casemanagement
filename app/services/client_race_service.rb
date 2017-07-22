class ClientRaceService
	def self.create_and_update_client_race_and_notes(arg_client_object,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_client_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_object.id, # entity_id = Client id
	                                        6472,  # notes_type = expense
	                                        arg_client_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            else
	            	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            		NotesService.delete_notes(6150,arg_client_object.id,6472,arg_client_object.id)
	            end
            end
            msg = "SUCCESS"
          	rescue => err
              	error_object = CommonUtil.write_to_attop_error_log_table("ClientRace-Model","create_and_update_client_race_and_notes",err,AuditModule.get_current_user.uid)
              	msg = "Failed to save client race - for more details refer to error ID: #{error_object.id}."
        end
	end

end