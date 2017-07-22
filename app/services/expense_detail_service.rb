class ExpenseDetailService
	def self.create_client_expense_detail_and_notes(arg_expense_detail_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_expense_detail_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6504,  # notes_type = expensedetail
	                                        arg_expense_detail_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetail-model","create_client_expense_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save expense detail - for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.update_client_expense_detail_and_notes(arg_expense_detail_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_expense_detail_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6504,  # notes_type = expensedetail
	                                        arg_expense_detail_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_id,6504,arg_expense_detail_object.id)
		        end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetail-Model","update_client_expense_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update expense detail- for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.delete_client_expense_detail_and_notes(arg_expense_detail_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_expense_detail_object.destroy!
	            if arg_notes.present?
		          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_id,6504,arg_expense_detail_object.id)
	            end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ExpenseDetail-Model","delete_client_expense_detail_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to delete expense detail - for more details refer to error ID: #{error_object.id}."
        end
	end
end