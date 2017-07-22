class ClientDemographicsService
	def self.create_client(arg_client_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_client_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_object.id, # entity_id = Client id
	                                        6471,  # notes_type = client
	                                        arg_client_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
			end
			return arg_client_object
	        rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("Client-Model","create_client",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to create client - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.update_client(arg_client_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				msg = process_biographic_information_changes(arg_client_object)
	            # Event to action mapping call should be before same in order to validate the attribute changes
	            # arg_client_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_object.id, # entity_id = Client id
	                                        6471,  # notes_type = client
	                                        arg_client_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            else
	            	# delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_object.id,6471,arg_client_object.id)
	            end
			end
			return arg_client_object
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("Client-Model","update_client",err,AuditModule.get_current_user.uid)
			msg = "Failed to update client - for more details refer to error ID: #{error_object.id}."
			return msg
		end
	end

	def self.process_biographic_information_changes(arg_client_object)
		ls_msg = nil
		if arg_client_object.biographic_information_changed && ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_object.id)
			ls_msg = call_event_management_service(arg_client_object)
		elsif arg_client_object.death_date_changed? && ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_object.id)
			ls_msg = call_event_management_service(arg_client_object)
		else
			arg_client_object.save!
        end
        return ls_msg
	end

	def self.call_event_management_service(arg_client_object)
		# step1 : Populate common event management argument structure
		common_action_argument_object = CommonEventManagementArgumentsStruct.new
        common_action_argument_object.client_id = arg_client_object.id
        common_action_argument_object.model_object = arg_client_object
        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_object.id)
        common_action_argument_object.changed_attributes = arg_client_object.changed_attributes().keys
        common_action_argument_object.is_a_new_record = arg_client_object.new_record?
        arg_client_object.save!
		ls_msg = EventManagementService.process_event(common_action_argument_object)
		return ls_msg
	end

	def self.trigger_events_for_immunization_attr_changes(arg_client_object)
		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_object.id)
			ls_msg = call_event_management_service(arg_client_object)
		end
	end
end