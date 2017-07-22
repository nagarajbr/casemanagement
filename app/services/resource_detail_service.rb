class ResourceDetailService
	def self.create_client_resource_detail_and_notes(arg_resource_detail_object,arg_client_id,arg_notes)
		msg = nil
		begin
            ActiveRecord::Base.transaction do
            	msg = process_actions_for_resource_change(arg_resource_detail_object, arg_client_id)
            	# arg_resource_detail_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6511,  # notes_type = resourcedetail
	                                        arg_resource_detail_object.id, # reference_id = resource ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("resourceDetail-model","create_client_resource_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save resource detail - for more details refer to error ID: #{error_object.id}."
        end
        return msg
	end

	def self.update_resource_detail_and_notes(arg_resource_detail_object,arg_client_id,arg_notes)
		msg = nil
		begin
            ActiveRecord::Base.transaction do
            	msg = process_actions_for_resource_change(arg_resource_detail_object, arg_client_id)
            	# arg_resource_detail_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6511,  # notes_type = resourcedetail
	                                        arg_resource_detail_object.id, # reference_id = resource ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_id,6511,arg_resource_detail_object.id)
		        end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("resourceDetail-Model","update_client_resource_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update resource detail- for more details refer to error ID: #{error_object.id}."
        end
        return msg
	end

	def self.delete_client_resource_detail_and_notes(arg_resource_detail_object,arg_client_id,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
	          arg_resource_detail_object.destroy!
	          if arg_notes.present?
	          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            	NotesService.delete_notes(6150,arg_client_id,6511,arg_resource_detail_object.id)
	          end
	    end
	        msg = "SUCCESS"
	    rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("resourceDetail-Model","delete_client_resource_detail_and_notes",err,AuditModule.get_current_user.uid)
	          msg = "Failed to update resource detail - for more details refer to error ID: #{error_object.id}."
	    end
	end

	def self.process_actions_for_resource_change(arg_resource_detail_object, arg_client_id)
		msg = nil
		if arg_resource_detail_object.resource_value_changed?
    		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id)
				# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.client_id = arg_client_id
		        common_action_argument_object.model_object = arg_resource_detail_object
		        common_action_argument_object.program_unit_id = ProgramUnit.get_open_client_program_units(arg_client_id).first.id
		        common_action_argument_object.changed_attributes = arg_resource_detail_object.changed_attributes().keys
		        common_action_argument_object.is_a_new_record = arg_resource_detail_object.new_record?
		        common_action_argument_object.run_month = arg_resource_detail_object.resource_valued_date
				arg_resource_detail_object.save!
				ls_msg = EventManagementService.process_event(common_action_argument_object)
			else
				arg_resource_detail_object.save!
	        end
        end
        return msg
	end
end