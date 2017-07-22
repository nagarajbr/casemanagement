class ResourceAdjustmentService

	def self.save_resource_adjust(arg_resource_adjustment,arg_cleint_id,arg_resource_detail_object)
		begin
	        ActiveRecord::Base.transaction do
				ResourceAdjustmentService.process_actions_for_resource_adjust_change(arg_resource_adjustment,arg_cleint_id,arg_resource_detail_object)
	      	end
	        msg = "SUCCESS"
	    rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("ResourceAdjustment-Model","save_resource_adjust",err,AuditModule.get_current_user.uid)
	          msg = "Failed to save resource adjustment - for more details refer to error ID: #{error_object.id}."
	    end
	end

	def self.process_actions_for_resource_adjust_change(arg_resource_adjust_object, arg_client_id,arg_resource_detail_object)
		msg = nil
    		if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id)
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
		        common_action_argument_object.client_id = arg_client_id
		        common_action_argument_object.model_object = arg_resource_adjust_object
		        common_action_argument_object.program_unit_id = ProgramUnit.get_open_client_program_units(arg_client_id).first.id
		        common_action_argument_object.changed_attributes = arg_resource_adjust_object.changed_attributes().keys
		        common_action_argument_object.is_a_new_record = arg_resource_adjust_object.new_record?
		        common_action_argument_object.run_month = arg_resource_detail_object.resource_valued_date
		        arg_resource_adjust_object.save!
				ls_msg = EventManagementService.process_event(common_action_argument_object)
			else
				arg_resource_adjust_object.save!
	        end
        return msg
	end

end