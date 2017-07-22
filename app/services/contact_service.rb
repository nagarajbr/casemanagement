class ContactService

	def self.create(arg_params, arg_entity, arg_entity_type)
		result_hash = {}
		@phones_error_messages = Phone.new
		if arg_params[:primary].present?
			primary_phone = build_phone_record(4661, arg_params[:primary])
		end

		if arg_params[:secondary].present?
			secondary_phone = build_phone_record(4662, arg_params[:secondary])
		end

		if arg_params[:other].present?
			other_phone = build_phone_record(4663, arg_params[:other])
		end

		case arg_entity_type
		when 6150
			if arg_params[:email_address].present?
				arg_entity.client_email = arg_params[:email_address]
				validate_email_address(arg_entity.client_email)
			end
		when 6152
			if arg_params[:email_address].present?
				arg_entity.email_address = arg_params[:email_address]
				validate_email_address(arg_entity.email_address)
			end
			# if arg_params[:notes].present?
			# 	arg_entity.notes = arg_params[:notes]
			# end
		when 6151
			if arg_params[:email_address].present?
				arg_entity.email_address = arg_params[:email_address]
				validate_email_address(arg_entity.email_address)
			end
			# if arg_params[:notes].present?
			# 	arg_entity.notes = arg_params[:notes]
			# end
		when 6338
			if arg_params[:email_address].present?
				arg_entity.email_address = arg_params[:email_address]
				validate_email_address(arg_entity.email_address)
			end
			# if arg_params[:contact_notes].present?
			# 	arg_entity.contact_notes = arg_params[:contact_notes]
			# end
		end



		unless @phones_error_messages.errors.full_messages.present?
			msg = nil
			begin
				ActiveRecord::Base.transaction do
					if arg_params[:primary].present?
						primary_phone.save!
						create_or_update_an_entry_in_entity_phones(arg_entity_type, arg_entity.id, primary_phone.id, EntityPhone.new)
					end
					if arg_params[:secondary].present?
						secondary_phone.save!
						create_or_update_an_entry_in_entity_phones(arg_entity_type, arg_entity.id, secondary_phone.id, EntityPhone.new)
					end
					if arg_params[:other].present?
						other_phone.save!
						create_or_update_an_entry_in_entity_phones(arg_entity_type, arg_entity.id, other_phone.id, EntityPhone.new)
					end

					case arg_entity_type
					when 6150
						if arg_params[:email_address].present?
							arg_entity.save!
						end
					when 6152
						if arg_params[:email_address].present? || arg_params[:notes].present?
							arg_entity.save!
						end
					when 6151
						if arg_params[:email_address].present? || arg_params[:notes].present?
							arg_entity.save!
						end

					when 6338
						if arg_params[:email_address].present? || arg_params[:notes].present?
							arg_entity.save!
						end
				    end
				    if arg_params[:notes].present?
						NotesService.save_notes(arg_entity_type, # entity_type = Client
                                        arg_entity.id, # entity_id = Client id
                                        6039,  # notes_type = client
                                        nil, # Ex: reference_id = income ID
                                        arg_params[:notes]) # notes
					end
			    end
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("ContactService","create",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to save contact information - for more details refer to error ID: #{error_object.id}."
			end
		end
		result_hash[:errors_object] = @phones_error_messages
		result_hash[:exception_msg] = msg
		return result_hash
	end

	def self.build_phone_record(arg_phone_type, arg_phone_number)
		phone = Phone.new
		phone.phone_type = arg_phone_type
		phone.phone_number = arg_phone_number
		is_phone_record_valid(phone)
		return phone
	end

	def self.is_phone_record_valid(arg_phone_record)
		result = true
		unless arg_phone_record.valid?
			result =  false
			arg_phone_record.errors.full_messages.each do |msg|
				@phones_error_messages.errors[:base] << CodetableItem.get_short_description(arg_phone_record.phone_type) + " " + msg
			end
		end
	end

	def self.create_or_update_an_entry_in_entity_phones(arg_entity_type, arg_entity_id, arg_phone_id, arg_entity_phone_record)
		entity_phone = arg_entity_phone_record
		entity_phone.entity_type = arg_entity_type
		entity_phone.entity_id = arg_entity_id
		entity_phone.phone_id = arg_phone_id
		entity_phone.save!
	end

	def self.update(arg_params, arg_entity, arg_entity_type,arg_client_email)
		result_hash = {}
		@phones_error_messages = Phone.new
		phones = Phone.get_entity_contact_list(arg_entity.id, arg_entity_type)
		update_entity = false
		@primary_phone = phones.where("phone_type = 4661")
		if @primary_phone.present?
			@primary_phone = @primary_phone.first
		end
		@secondary_phone = phones.where("phone_type = 4662")
		if @secondary_phone.present?
			@secondary_phone = @secondary_phone.first
		end
		@other_phone = phones.where("phone_type = 4663")
		if @other_phone.present?
			@other_phone = @other_phone.first
		end

		primary_result = check_type_of_update_action(arg_params[:primary], @primary_phone, 4661)
		secondary_result = check_type_of_update_action(arg_params[:secondary], @secondary_phone, 4662)
		other_result = check_type_of_update_action(arg_params[:other], @other_phone, 4663)
		# notes = NotesService.get_notes(arg_entity_type,arg_entity.id,6039,nil)
		case arg_entity_type
		when 6150
			if (arg_params[:email_address].present? and arg_params[:email_address]) != (arg_client_email.present? and arg_client_email.email_address)
				# arg_client_email.email_address = arg_params[:email_address]
				if validate_email_address(arg_params[:email_address]) == nil
					#email is in right format
				   update_entity = true
				end
			end
		when 6152
			if arg_params[:email_address] != arg_entity.email_address
				arg_entity.email_address = arg_params[:email_address]
				validate_email_address(arg_entity.email_address)
				update_entity = true
			end
			# if arg_params[:notes] != arg_entity.notes
			# 	arg_entity.notes = arg_params[:notes]
			# 	update_entity = true
			# end
		when 6151
			if arg_params[:email_address] != arg_entity.email_address
				arg_entity.email_address = arg_params[:email_address]
				validate_email_address(arg_entity.email_address)
				update_entity = true
			end
			# if arg_params[:notes] != arg_entity.notes
			# 	arg_entity.notes = arg_params[:notes]
			# 	update_entity = true
			# end
			when 6338
			if arg_params[:email_address] != arg_entity.email_address
				arg_entity.email_address = arg_params[:email_address]
				validate_email_address(arg_entity.email_address)
				update_entity = true
			end

			# if arg_params[:contact_notes] != arg_entity.contact_notes
			# 	arg_entity.contact_notes = arg_params[:contact_notes]
			# 	update_entity = true
			# end
		end


		unless @phones_error_messages.errors.full_messages.present?
			msg = nil
			begin
				ActiveRecord::Base.transaction do
					perform_necessary_update(primary_result, @primary_phone, arg_entity.id, arg_entity_type)
					perform_necessary_update(secondary_result, @secondary_phone, arg_entity.id, arg_entity_type)
					perform_necessary_update(other_result, @other_phone, arg_entity.id, arg_entity_type)
					case arg_entity_type
						when 6150
							if update_entity
                                 client_email_collection = ClientEmail.where("client_id = ?",arg_entity.id)
                                 if client_email_collection.present?
                                 	#update email
                                 	client_email = client_email_collection.first
                                 	client_email.email_address = arg_params[:email_address]
                                 	client_email.save!
                                 else
                                 	#new email
                                 	client_email = ClientEmail.new
                                 	client_email.client_id = arg_entity.id
                                 	client_email.email_address = arg_params[:email_address]
                                 	client_email.save!
                                 end
							end
						when 6152
							if update_entity
								arg_entity.save!
							end
						when 6151
							if update_entity
								arg_entity.save!
							end
						when 6338
							if update_entity
								arg_entity.save!
							end
					end
					if arg_params[:notes].present? #&& notes.present? && arg_params[:notes] != notes) ||
						#(arg_params[:notes].present? && !(notes.present?))
						NotesService.save_notes(arg_entity_type, # entity_type = Client
                                    arg_entity.id, # entity_id = Client id
                                    6474,  # notes_type = client
                                    nil, # Ex: reference_id = income ID
                                    arg_params[:notes]) # notes
					# elsif arg_params[:notes].blank? && notes.present?
					# 	NotesService.delete_notes(arg_entity_type,arg_entity.id,6039,nil)
					end
				end
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("ContactService","update",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to save contact information - for more details refer to error ID: #{error_object.id}."
			end
		end
		result_hash[:errors_object] = @phones_error_messages
		result_hash[:exception_msg] = msg
		return result_hash
	end

	def self.check_type_of_update_action(arg_params_value, arg_phone_record, arg_phone_type)
		result = ""
		if arg_phone_record.present?
			if arg_params_value.present?
				if arg_phone_record.phone_number != arg_params_value
					result = "update"
					arg_phone_record.phone_number = arg_params_value
					is_phone_record_valid(arg_phone_record)
				end
			else
				arg_phone_record.phone_number = arg_params_value
				result = "destroy"
			end
		else
			if arg_params_value.present?
				arg_phone_record = build_phone_record(arg_phone_type, arg_params_value)
				result = "new"
			end
		end
		case arg_phone_type
			when 4661
				@primary_phone = arg_phone_record
			when 4662
				@secondary_phone = arg_phone_record
			when 4663
				@other_phone = arg_phone_record
		end
		return result
	end

	def self.perform_necessary_update(arg_action_type, arg_phone_record, arg_entity_id, arg_entity_type)
		# fail
		if arg_action_type == "new"
			arg_phone_record.save!
			create_or_update_an_entry_in_entity_phones(arg_entity_type, arg_entity_id, arg_phone_record.id, EntityPhone.new)
		elsif arg_action_type == "update"
			arg_phone_record.save!
		elsif arg_action_type == "destroy"
			EntityPhone.delete_record(arg_entity_type, arg_entity_id, arg_phone_record.id)
			arg_phone_record.destroy
		end
	end

	def self.validate_email_address(arg_email_address)
		# result = arg_client.valid_email_address?
		# if result.present?
		# 	@phones_error_messages.errors[:base] <<  result
		# end
		if (arg_email_address.present? && ((arg_email_address.to_s =~ /\A\S+@.+\.\S+\z/).nil?))
			@phones_error_messages.errors[:base] << "Email address is not valid. It must be in the format: username@domain.com"
    	end
    	# fail
	end

end