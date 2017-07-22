class IncomeDetailService
	def self.create_client_income_detail_and_notes(arg_income_detail_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	msg = process_actions_for_income_details_change(arg_income_detail_object, arg_client_id,nil)
            	# arg_income_detail_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6503,  # notes_type = incomedetail
	                                        arg_income_detail_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetail-model","create_client_income_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save income detail - for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.update_client_income_detail_and_notes(arg_income_detail_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	msg = process_actions_for_income_details_change(arg_income_detail_object, arg_client_id,nil)
            	# arg_income_detail_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6503,  # notes_type = incomedetail
	                                        arg_income_detail_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_id,6503,arg_income_detail_object.id)
		        end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetail-Model","update_client_income_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update income detail- for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.delete_client_income_detail_and_notes(arg_income_detail_object,arg_client_id,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
	        msg = process_actions_for_income_details_change(arg_income_detail_object, arg_client_id,438)
	          arg_income_detail_object.destroy!
	          if arg_notes.present?
	          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            	NotesService.delete_notes(6150,arg_client_id,6503,arg_income_detail_object.id)
	          end
	    end
	        msg = "SUCCESS"
	    rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("IncomeDetail-Model","delete_client_income_detail_and_notes",err,AuditModule.get_current_user.uid)
	          msg = "Failed to update income detail - for more details refer to error ID: #{error_object.id}."
	    end
	end

	def self.process_actions_for_income_details_change(arg_income_detail_object, arg_client_id,arg_event_id)
		 ls_msg = nil
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_client_id)
          common_action_argument_object = CommonEventManagementArgumentsStruct.new
          common_action_argument_object.client_id = arg_client_id
          common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
          common_action_argument_object.run_month = arg_income_detail_object.date_received
          if arg_event_id.present?
            common_action_argument_object.event_id = arg_event_id #event id for out of state payments controller
          else
            common_action_argument_object.model_object = arg_income_detail_object
            common_action_argument_object.changed_attributes = arg_income_detail_object.changed_attributes().keys
            common_action_argument_object.is_a_new_record = arg_income_detail_object.new_record?
          end
          arg_income_detail_object.save!
          ls_msg = EventManagementService.process_event(common_action_argument_object)
        else
          arg_income_detail_object.save!
        end
      return ls_msg
	end
end