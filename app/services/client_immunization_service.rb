class ClientImmunizationService
	def self.creat_client_immunization_and_notes(arg_exempt_from_immunization,arg_notes,arg_immunizations_record,arg_client)
		begin
            ActiveRecord::Base.transaction do
            	if arg_exempt_from_immunization.present?
					arg_client.exempt_from_immunization = arg_exempt_from_immunization
					ClientDemographicsService.trigger_events_for_immunization_attr_changes(arg_client)
					arg_client.save!
				end

				if arg_immunizations_record.present?
					@client_immunization = ClientImmunization.new
					@client_immunization.client_id = arg_client.id
					@client_immunization.immunizations_record = arg_immunizations_record
					ClientImmunizationService.trigger_events_for_immunization_attr_changes(@client_immunization, arg_client.id)
					@client_immunization.save!
				end

				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client.id, # entity_id = Client id
	                                        6050,  # notes_type = income
	                                        arg_client.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
          	rescue => err
            	error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunization-Model","creat_client_immunization_and_notes",err,AuditModule.get_current_user.uid)
              	msg = "Failed to save client immunization - for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.update_client_immunization_and_notes(arg_client_immunization_object,arg_client_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				ClientImmunizationService.trigger_events_for_immunization_attr_changes(arg_client_immunization_object, arg_client_object.id)
				arg_client_immunization_object.save!
				ClientDemographicsService.trigger_events_for_immunization_attr_changes(arg_client_object)
				arg_client_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                 NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_object.id, # entity_id = Client id
	                                        6050,  # notes_type = income
	                                        arg_client_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_object.id,6050,arg_client_object.id)
		        end
			end
			msg = "SUCCESS"
          	rescue => err
            	error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunization-Model","update_client_immunization_and_notes",err,AuditModule.get_current_user.uid)
              	msg = "Failed to update client immunization - for more details refer to error ID: #{error_object.id}."
		end
	end

	def self.delete_client_immunization_and_notes(arg_client_immunization_object,arg_notes_object,arg_client_object)
		begin
			ActiveRecord::Base.transaction do
				if arg_client_immunization_object.present?
					arg_client_immunization_object.destroy!
				end
				if arg_notes_object.present?
		          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_object.id,6050,arg_client_object.id)
		        end
				if arg_client_object.exempt_from_immunization.present?
					Client.where(:id => arg_client_object.id).update_all(:exempt_from_immunization => '')
				end
			end
			msg = "SUCCESS"
          	rescue => err
            	error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunization-Model","delete_client_immunization_and_notes",err,AuditModule.get_current_user.uid)
              	msg = "Failed to delete client immunization - for more details refer to error ID: #{error_object.id}."
		end
	end

	def self.trigger_events_for_immunization_attr_changes(arg_client_immunization_object, arg_client_id)
        ls_msg = nil
        	if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
	            common_action_argument_object.client_id = arg_client_id
	            common_action_argument_object.model_object = arg_client_immunization_object
	            common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
	            common_action_argument_object.changed_attributes = arg_client_immunization_object.changed_attributes().keys
	            ls_msg = EventManagementService.process_event(common_action_argument_object)
			end
        return ls_msg
    end
end