class IncomeService

	def self.create_client_income_and_notes(arg_client_id,arg_income_object,arg_notes)
        client_income_object = ClientIncome.new
        client_income_object.client_id = arg_client_id
         begin
            ActiveRecord::Base.transaction do
              IncomeService.trigger_events_for_incomes(arg_income_object, arg_client_id,nil)
              client_income_object.income_id = arg_income_object.id
              client_income_object.save!
              if arg_notes.present?
                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
                NotesService.save_notes(6150, # entity_type = Client
                                        arg_client_id, # entity_id = Client id
                                        6484,  # notes_type = income
                                        arg_income_object.id, # reference_id = income ID
                                        arg_notes) # notes
              end
          end
            msg = "SUCCESS"
          rescue => err
              error_object = CommonUtil.write_to_attop_error_log_table("Income-Model","save_client_income",err,AuditModule.get_current_user.uid)
              msg = "Failed to save income - for more details refer to error ID: #{error_object.id}."
          end
    end

    def self.update_client_income_and_notes(arg_client_id,arg_income_object,arg_notes)
      begin
        ActiveRecord::Base.transaction do
          IncomeService.trigger_events_for_incomes(arg_income_object, arg_client_id,nil)
          arg_income_object.save!
          if arg_notes.present?
                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
                NotesService.save_notes(6150, # entity_type = Client
                                        arg_client_id, # entity_id = Client id
                                        6484,  # notes_type = income
                                        arg_income_object.id, # reference_id = income ID
                                        arg_notes) # notes
          else
            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            NotesService.delete_notes(6150,arg_client_id,6484,arg_income_object.id)
          end
        end
        msg = "SUCCESS"
        rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("Income-Model","update_client_income",err,AuditModule.get_current_user.uid)
            msg = "Failed to update income - for more details refer to error ID: #{error_object.id}."
      end
    end

    def self.trigger_events_for_incomes(arg_client_income_object, arg_client_id,arg_event_id)
      ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
          common_action_argument_object = CommonEventManagementArgumentsStruct.new
          common_action_argument_object.client_id = arg_client_id
          common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
          if arg_event_id.present?
            common_action_argument_object.event_id = arg_event_id #event id for out of state payments controller
          else
            common_action_argument_object.model_object = arg_client_income_object
            common_action_argument_object.changed_attributes = arg_client_income_object.changed_attributes().keys
            common_action_argument_object.is_a_new_record = arg_client_income_object.new_record?
          end
          arg_client_income_object.save!
          ls_msg = EventManagementService.process_event(common_action_argument_object)
        else
          arg_client_income_object.save!
        end
      return ls_msg
    end

end