class IncomeDetailAdjustReasonService
	def self.process_actions_for_income_details_adjust_reason_change(arg_income_detail_adjust_reason_object, arg_client_id,arg_event_id,arg_date_received)
		 ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id)
          common_action_argument_object = CommonEventManagementArgumentsStruct.new
          common_action_argument_object.client_id = arg_client_id
          common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
          common_action_argument_object.run_month = arg_date_received
          if arg_event_id.present?
            common_action_argument_object.event_id = arg_event_id #event id for out of state payments controller
          else
            common_action_argument_object.model_object = arg_income_detail_adjust_reason_object
            common_action_argument_object.changed_attributes = arg_income_detail_adjust_reason_object.changed_attributes().keys
            common_action_argument_object.is_a_new_record = arg_income_detail_adjust_reason_object.new_record?
          end
          arg_income_detail_adjust_reason_object.save!
          ls_msg = EventManagementService.process_event(common_action_argument_object)
        else
          arg_income_detail_adjust_reason_object.save!
        end
      return ls_msg
	end
end