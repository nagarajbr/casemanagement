class SchoolService
	def self.create_school(arg_school_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_school_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6338, # entity_type = school
	                                        arg_school_object.id, # entity_id = school id
	                                        6523,  # notes_type = school
	                                        arg_school_object.id, # reference_id = school ID
	                                        arg_notes) # notes
	            end
			end
			return arg_school_object
	        rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("School-Model","create_school",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to create school - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end

	end

	def self.update_school(arg_school_object,arg_notes)
		begin
			ActiveRecord::Base.transaction do
				arg_school_object.save!
				if arg_notes.present?
	                # NotesService.save_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id,arg_notes)
	                NotesService.save_notes(6338, # entity_type = school
	                                        arg_school_object.id, # entity_id = school id
	                                        6523,  # notes_type = school
	                                        arg_school_object.id, # reference_id = school ID
	                                        arg_notes) # notes
	            else
	            	# delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
	            	NotesService.delete_notes(6338,arg_school_object.id,6523,arg_school_object.id)
	            end
			end
			return arg_school_object
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("School-Model","update_school",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to update school - for more details refer to error ID: #{error_object.id}."
	          	return msg
		end
	end

	def self.delete_school(arg_school_object,arg_addresses_object,arg_notes)
		begin
	        ActiveRecord::Base.transaction do
	          	arg_school_object.destroy!
	          	if arg_addresses_object.present?
					arg_addresses_object.each do |address|
						Address.destroy_by_id(address.id)
						EntityAddress.destroy_by_address_id(address.id)
					end
				end
	          if arg_notes.present?
	          	#NotesService.delete_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
            	NotesService.delete_notes(6338,arg_school_object,6523,arg_school_object.id)
	          end
	    end
	        msg = "SUCCESS"
	    rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("School-Model","delete_school",err,AuditModule.get_current_user.uid)
	          msg = "Failed to update school - for more details refer to error ID: #{error_object.id}."
	    end
	end
end