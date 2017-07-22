class ExpenseService
	def self.create_client_expense_and_notes(arg_expense_object,arg_client_id,arg_notes)
		client_expense_object = ClientExpense.new
        client_expense_object.client_id = arg_client_id
		begin
            ActiveRecord::Base.transaction do
            	arg_expense_object.save!
            	client_expense_object.expense_id = arg_expense_object.id
            	client_expense_object.save!

            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6485,  # notes_type = expense
	                                        arg_expense_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Expense-model","create_client_expense_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save expense - for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.update_client_expense_and_notes(arg_expense_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_expense_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6485,  # notes_type = expense
	                                        arg_expense_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_id,6485,arg_expense_object.id)
		        end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Expense-Model","update_client_expense_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update expense- for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.delete_client_expense_and_notes(arg_expense_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_expense_object.destroy!
	            if arg_notes.present?
		          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_id,6485,arg_expense_object.id)
	            end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Expense-Model","delete_client_expense_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to delete expense- for more details refer to error ID: #{error_object.id}."
        end
	end
end