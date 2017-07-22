class OutofstatePaymentService
	def self.create_outofstate_payments(arg_client_id,arg_from_date,arg_to_date,arg_state)
    all_out_of_state_pymts_are_valid = true
    reason = ""
		begin
            ActiveRecord::Base.transaction do

                count = 0
                oosps = []
                while arg_from_date <= arg_to_date
                  oosp = OutOfStatePayment.new
                  oosp.client_id = arg_client_id
                  oosp.payment_month = arg_from_date
                  # oosp.work_participation_status =  params[:out_of_state_payment][:work_participation_status]
                  oosp.state = arg_state
                  # OutofstatePaymentService.trigger_events_for_outofstate_payments(oosp, arg_client_id,778)
                  if oosp.valid?
                    oosps << oosp
                  else
                    all_out_of_state_pymts_are_valid = false
                    reason = oosp.errors.full_messages.first
                    break
                  end
                  arg_from_date = arg_from_date + 1.month
                end

                if all_out_of_state_pymts_are_valid
                  oosps.each do |oosp|
                    if oosp.save!
                      OutofstatePaymentService.trigger_events_for_outofstate_payments(oosp, arg_client_id,778) if count == 0
                      count = count + 1
                    end
                  end
                  if count > 0
                    time_limit = TimeLimit.get_details_by_client_id(arg_client_id)
                    if time_limit.present?
                      time_limit = time_limit.first
                      if time_limit.federal_count.present? && time_limit.federal_count >= 0
                        time_limit.federal_count = time_limit.federal_count + count
                      else
                        time_limit.federal_count = count
                      end
                      time_limit.save!
                    else
                      time_limit = TimeLimit.new
                      time_limit.client_id = arg_client_id
                      time_limit.federal_count = count
                      time_limit.tea_state_count = 0
                      time_limit.work_pays_state_count = 0
                      time_limit.save!
                    end
                  end
                end
            end
        end
        if all_out_of_state_pymts_are_valid
          msg = "SUCCESS"
        else
          msg = "#{reason}"
        end

        rescue => err
          	error_object = CommonUtil.write_to_attop_error_log_table("OutofstatePayment-Model","create_outofstate_payments",err,AuditModule.get_current_user.uid)
          	msg = "Failed to save payment information - for more details refer to error ID: #{error_object.id}."
	end

  def self.delete_outofstate_payments(arg_oosp_object,arg_client_id)
    begin
      ActiveRecord::Base.transaction do
        OutofstatePaymentService.trigger_events_for_outofstate_payments(arg_oosp_object, arg_client_id,468)
        arg_oosp_object.destroy!
        time_limit = TimeLimit.get_details_by_client_id(arg_client_id)
        time_limit = time_limit.first
        if time_limit.federal_count.present? && time_limit.federal_count >= 0
          time_limit.federal_count = time_limit.federal_count - 1
          time_limit.save!
        end
      end
      msg = "SUCCESS"
      rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("OutofstatePayment-Model","delete_outofstate_payments",err,AuditModule.get_current_user.uid)
            msg = "Failed to delete out of state payment - for more details refer to error ID: #{error_object.id}."
    end
  end

	def self.trigger_events_for_outofstate_payments(arg_oosp_object, arg_client_id,arg_event_id)
      ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_oosp_object.client_id)
          common_action_argument_object = CommonEventManagementArgumentsStruct.new
          common_action_argument_object.event_id = arg_event_id #event id for out of state payments controller
          common_action_argument_object.client_id = arg_oosp_object.client_id
          # common_action_argument_object.model_object = arg_oosp_object
          common_action_argument_object.out_of_state_payment_id = arg_oosp_object.id
          common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_oosp_object.client_id)
          # common_action_argument_object.changed_attributes = arg_oosp_object.changed_attributes().keys
          ls_msg = EventManagementService.process_event(common_action_argument_object)
        end
      return ls_msg
	end

end