class ResourceService

	def self.save_client_resource(arg_client_id,arg_params,arg_notes)
        resource_object = Resource.new(arg_params)
        client_resource_object = ClientResource.new
        client_resource_object.client_id = arg_client_id
         begin
            ActiveRecord::Base.transaction do
              ResourceService.trigger_events_for_resources(resource_object, arg_client_id,nil)
              resource_object.save!
              client_resource_object.resource_id = resource_object.id
              Rails.logger.debug("**client_resource_object = #{client_resource_object.inspect}")
              client_resource_object.save!
              if arg_notes.present?
                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
                NotesService.save_notes(6150, # entity_type = Client
                                        arg_client_id, # entity_id = Client id
                                        6486,  # notes_type = Resource
                                        resource_object.id, # reference_id = income ID
                                        arg_notes) # notes
              end
          end
            msg = "SUCCESS"
          rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("Resource-Model","save_client_resource",err,AuditModule.get_current_user.uid)
              msg = "Failed to save resource - for more details refer to error ID: #{error_object.id}."
          end
    end

	def self.update_client_resource(arg_client_id,arg_resource_object,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
              ResourceService.trigger_events_for_resources(arg_resource_object, arg_client_id,nil)
            	# arg_resource_object.save!
              if arg_notes.present?
                  # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
                  NotesService.save_notes(6150, # entity_type = Client
                                        arg_client_id, # entity_id = Client id
                                        6486,  # notes_type = Resource
                                        arg_resource_object.id, # reference_id = income ID
                                        arg_notes) # notes
              else
                #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
                NotesService.delete_notes(6150,arg_client_id,6486,arg_resource_object.id)
              end
	        end
	        msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Resource-Model","update_client_resource",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update resource - for more details refer to error ID: #{error_object.id}."
      	end
	end

	def self.destroy_resource(arg_resource_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
              ResourceService.trigger_events_for_resources(arg_resource_object, arg_client_id,564)
            	arg_resource_object.destroy!
	            if arg_notes.present?
		          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_id,6486,arg_resource_object.id)
	            end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Resource-Model","destroy_resource",err,AuditModule.get_current_user.uid)
	            msg = "Failed to delete resource- for more details refer to error ID: #{error_object.id}."
        end

	end

  def self.trigger_events_for_resources(arg_resource_object, arg_client_id,arg_event_id)
      ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
          common_action_argument_object = CommonEventManagementArgumentsStruct.new
          common_action_argument_object.client_id = arg_client_id
          common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
          if arg_event_id.present?
            common_action_argument_object.event_id = arg_event_id #event id for out of state payments controller
          else
            common_action_argument_object.model_object = arg_resource_object
            common_action_argument_object.changed_attributes = arg_resource_object.changed_attributes().keys
            common_action_argument_object.is_a_new_record = arg_resource_object.new_record?
          end
          arg_resource_object.save!
          ls_msg = EventManagementService.process_event(common_action_argument_object)
        else
          arg_resource_object.save!
        end
      return ls_msg
  end

end