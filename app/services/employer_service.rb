class EmployerService

	def self.create_employer(arg_employer_object,arg_employer_params,arg_params,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_employer_object.save!
				if (arg_employer_params[:flag].present? && arg_employer_params[:flag].to_i == 1 && Provider.if_tax_id_ssn_is_not_present(arg_params[:employer][:federal_ein]))
					#Employer.validate_data_for_employer(arg_params[:flag])
					provider = Provider.new
					provider.provider_type = 6139 # "Business"
					provider.tax_id_ssn = arg_params[:employer][:federal_ein]
					provider.provider_name = arg_params[:employer][:employer_name]
					provider.provider_country_code = arg_params[:employer][:employer_country_code]
					provider.contact_person = arg_params[:employer][:employer_contact]
					provider.status = 6155 #pending
					if provider.save!
						provider = Provider.find(provider.id)
						provider.head_office_provider_id = provider.id
	                    provider.save!
					end
				end
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6152, # entity_type = employer
	                                        arg_employer_object.id, # entity_id = Client id
	                                        6522,  # notes_type = employer
	                                        arg_employer_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            end
			end
			return arg_employer_object
	        rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("Employer-Model","create_employer",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to create employer - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.update_employer(arg_employer_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_employer_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6152, # entity_type = employer
	                                        arg_employer_object.id, # entity_id = Client id
	                                        6522,  # notes_type = employer
	                                        arg_employer_object.id, # reference_id = income ID
	                                        arg_notes) # notes
	            else
	            	# delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6152,arg_employer_object.id,6522,arg_employer_object.id)
	            end
			end
			return arg_employer_object
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("Employer-Model","update_employer",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to update employer - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

end