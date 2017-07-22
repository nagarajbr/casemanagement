class ResourceUsesService
	def self.save_resource_uses(arg_resource_uses_object,arg_client_id,arg_resource_detail)
		msg = nil
		begin
            ActiveRecord::Base.transaction do
            	msg = process_actions_for_resource_uses_change(arg_resource_uses_object, arg_client_id,arg_resource_detail)
            	# arg_resource_detail_object.save!
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ResourceUses-model","create_resource_uses",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save resource uses - for more details refer to error ID: #{error_object.id}."
        end
        return msg
	end

	def self.process_actions_for_resource_uses_change(arg_resource_uses_object, arg_client_id,arg_resource_detail)
		msg = nil
    		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id)
				# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.client_id = arg_client_id
		        common_action_argument_object.model_object = arg_resource_uses_object
		        common_action_argument_object.program_unit_id = ProgramUnit.get_open_client_program_units(arg_client_id).first.id
		        common_action_argument_object.changed_attributes = arg_resource_uses_object.changed_attributes().keys
		        common_action_argument_object.is_a_new_record = arg_resource_uses_object.new_record?
		        common_action_argument_object.run_month = arg_resource_detail.resource_valued_date
		        arg_resource_uses_object.save!
				ls_msg = EventManagementService.process_event(common_action_argument_object)
			else
				arg_resource_uses_object.save!
	        end
        return msg
	end
end