class DisabilityService
	def self.create_disability_and_notes(arg_disability_object,arg_notes)
	     begin
	        ActiveRecord::Base.transaction do
	          arg_disability_object.save!
	          if arg_notes.present?
	            # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	            NotesService.save_notes(6150, # entity_type = Client
	                                    arg_disability_object.client_id, # entity_id = Client id
	                                    6482,  # notes_type = disability
	                                    arg_disability_object.client_id, # reference_id = income ID
	                                    arg_notes) # notes
	          end
	      end
	        msg = "SUCCESS"
	      rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("Disability-Model","create_diability_and_notes",err,AuditModule.get_current_user.uid)
	          msg = "Failed to save disability - for more details refer to error ID: #{error_object.id}."
	      end

	end
	def self.update_disability_and_notes(arg_disability_object,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
	          arg_disability_object.save!
	          if arg_notes.present?
	            # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	            NotesService.save_notes(6150, # entity_type = Client
	                                    arg_disability_object.client_id, # entity_id = Client id
	                                    6482,  # notes_type = disability
	                                    arg_disability_object.client_id, # reference_id = income ID
	                                    arg_notes) # notes
	          else
	          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            	NotesService.delete_notes(6150,arg_disability_object.client_id,6482,arg_disability_object.client_id)
	          end
	      end
	        msg = "SUCCESS"
	      rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("Disability-Model","update_diability_and_notes",err,AuditModule.get_current_user.uid)
	          msg = "Failed to update disability - for more details refer to error ID: #{error_object.id}."
	      end
	end

	def self.delete_disability_and_notes(arg_disability_object,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
	          arg_disability_object.destroy!
	          if arg_notes.present?
	          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            	NotesService.delete_notes(6150,arg_disability_object.client_id,6482,arg_disability_object.client_id)
	          end
	      end
	        msg = "SUCCESS"
	      rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("Disability-Model","delete_disability_and_notes",err,AuditModule.get_current_user.uid)
	          msg = "Failed to disability disability - for more details refer to error ID: #{error_object.id}."
	      end
	end
end