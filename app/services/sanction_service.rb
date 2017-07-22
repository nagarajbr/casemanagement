class SanctionService
	def self.create_client_sanction_and_notes(arg_santion_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_santion_object.save!
            	call_event_management_service(arg_santion_object,arg_client_id)
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6489,  # notes_type = Sanction
	                                        arg_santion_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Sanction-model","create_client_sanction_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save sanction - for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.update_client_sanction_and_notes(arg_santion_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	if arg_santion_object.infraction_end_date.present?
            		sanction_detail_object = SanctionDetail.where("sanction_id = ?",arg_santion_object.id).order("id DESC").first
            		if sanction_detail_object.present? && sanction_detail_object.release_indicatior == '1'
            			#close task #delete queue
            			SanctionService.close_worktask_delete_queue(arg_santion_object,arg_client_id)
            			SanctionService.perform_sanction_release_process(arg_santion_object,arg_client_id,sanction_detail_object)
            			arg_santion_object.compliance_office_id = nil
            		elsif sanction_detail_object.blank?
            			#close task  #delete queue
            			SanctionService.close_worktask_delete_queue(arg_santion_object,arg_client_id)
            			arg_santion_object.compliance_office_id = nil
            		end
            	end

            	arg_santion_object.save!

            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6150, # entity_type = Client
	                                        arg_client_id, # entity_id = Client id
	                                        6489,  # notes_type = Sanction
	                                        arg_santion_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6150,arg_client_id,6489,arg_santion_object.id)
		        end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Sanction-Model","update_client_sanction_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update sanction- for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.delete_client_sanction_and_notes(arg_santion_object,arg_client_id,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_santion_object.destroy!
	            if arg_notes.present?
		          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6150,arg_client_id,6489,arg_santion_object.id)
	            end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("Sanction-Model","delete_client_sanction_and_notes",err,AuditModule.get_current_user.uid)
	            msg = "Failed to delete sanction- for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.call_event_management_service(arg_santion_object,arg_client_id)
		common_action_argument_object = CommonEventManagementArgumentsStruct.new
        common_action_argument_object.client_id = arg_client_id
        common_action_argument_object.event_id = 595 # Creating a sanction
        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
        common_action_argument_object.sanction_type = arg_santion_object.sanction_type
        # arguments needed for queue service
        common_action_argument_object.queue_reference_type = 6367 # sanction
        common_action_argument_object.queue_reference_id = arg_santion_object.id
		ls_msg = EventManagementService.process_event(common_action_argument_object)
		return ls_msg
	end

	def self.close_worktask_delete_queue(arg_santion_object,arg_client_id)
		common_action_argument_object = CommonEventManagementArgumentsStruct.new
		common_action_argument_object.client_id = arg_client_id
        common_action_argument_object.event_id = 730 # closing atask and deleting work queue
        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
        common_action_argument_object.sanction_id = arg_santion_object.id
        # arguments needed for queue service
        common_action_argument_object.queue_reference_type = 6367 # sanction
        common_action_argument_object.queue_reference_id = arg_santion_object.id
		ls_msg = EventManagementService.process_event(common_action_argument_object)
		return ls_msg
	end

	def self.perform_sanction_release_process(arg_santion_object,arg_client_id,arg_sanction_detail_object)
		common_action_argument_object = CommonEventManagementArgumentsStruct.new
		common_action_argument_object.client_id = arg_client_id
        common_action_argument_object.event_id = 825 # closing atask and deleting work queue
        common_action_argument_object.model_object = arg_sanction_detail_object
        common_action_argument_object.changed_attributes = arg_sanction_detail_object.changed_attributes().keys
        common_action_argument_object.sanction_id = arg_santion_object.id
        common_action_argument_object.sanction_type = arg_santion_object.sanction_type
        common_action_argument_object.program_unit_id =  ProgramUnit.get_open_program_unit_for_client(arg_client_id)
        ls_msg = EventManagementService.process_event(common_action_argument_object)
		return ls_msg
	end

end