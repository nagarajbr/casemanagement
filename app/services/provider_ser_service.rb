class ProviderSerService
	def self.create_provider_service(arg_providerservice_object,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_providerservice_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6151, # entity_type = Provider
	                                        arg_providerservice_object.provider_id, # entity_id = Client id
	                                        6521,  # notes_type = provider service
	                                        arg_providerservice_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
            end
            msg = "SUCCESS"
	        rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ProviderService-model","create_provider_service",err,AuditModule.get_current_user.uid)
	            msg = "Failed to save provider service - for more details refer to error ID: #{error_object.id}."
        end
	end

	def self.update_provider_service(arg_providerservice_object,arg_notes)
		begin
            ActiveRecord::Base.transaction do
            	arg_providerservice_object.save!
            	if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6151, # entity_type = Client
	                                        arg_providerservice_object.provider_id, # entity_id = Client id
	                                        6521,  # notes_type = expense
	                                        arg_providerservice_object.id, # reference_id = income ID
	                                        arg_notes) # notes
		        else
		            #NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
		            NotesService.delete_notes(6151,arg_providerservice_object.provider_id,6521,arg_providerservice_object.id)
		        end
            end
            msg = "SUCCESS"
        	rescue => err
	            error_object = CommonUtil.write_to_attop_error_log_table("ProviderService-Model","update_provider_service",err,AuditModule.get_current_user.uid)
	            msg = "Failed to update provider service- for more details refer to error ID: #{error_object.id}."
        end
	end

end