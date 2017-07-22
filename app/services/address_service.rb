class AddressService

	def self.create(arg_address_struct)
		client = arg_address_struct.entity_obj
		@addresses_error_messages = Address.new
		@address = Address.new
		mailing_address = ""
		non_mailing_address = ""

		if check_for_presence_of_mailing_address(arg_address_struct.address_parameters)
			mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, Address.new,arg_address_struct.entity_type)
			validate_address_information(mailing_address)
		end

		if arg_address_struct.address_parameters[:non_mailing_addr_same_as_mailing] == "Y"
			non_mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, Address.new,arg_address_struct.entity_type)
			non_mailing_address.address_type = arg_address_struct.address_parameters[:non_mailing_address_type]
		else
			if check_for_presence_of_non_mailing_address(arg_address_struct.address_parameters)
				non_mailing_address = Address.new
				non_mailing_address = build_non_mailing_address_object(arg_address_struct.address_parameters, Address.new,arg_address_struct.entity_type)
			end
		end

		if non_mailing_address.present?
			validate_address_information(non_mailing_address)
		end

		if @addresses_error_messages.errors.full_messages.present?
			if mailing_address.present?
				@address = mailing_address
			end
			if non_mailing_address.present?
				populate_non_mailing_address_in_address_instance(non_mailing_address)
			end
			@address.non_mailing_address_type = arg_address_struct.address_parameters[:non_mailing_address_type]
			@address.address_type = arg_address_struct.address_parameters[:address_type]
			arg_address_struct.addresses_error_messages_obj =  @addresses_error_messages
			arg_address_struct.address_obj = @address
		else
			msg = nil
			begin
				ActiveRecord::Base.transaction do
					if mailing_address.present?
						mailing_address.save! if arg_address_struct.can_save
						insert_into_entity_address(arg_address_struct, mailing_address)
						# ea_mailing = EntityAddress.new
						# ea_mailing.entity_type = arg_address_struct.entity_type
						# ea_mailing.entity_id = client.id
						# ea_mailing.address_id = mailing_address.id
						# ea_mailing.save!
					end
					if non_mailing_address.present?
						non_mailing_address.client_id = arg_address_struct.client_id if arg_address_struct.entity_type == 6150
						non_mailing_address.save! if arg_address_struct.can_save
						insert_into_entity_address(arg_address_struct, non_mailing_address)
						# ea_non_mailing = EntityAddress.new
						# ea_non_mailing.entity_type = arg_address_struct.entity_type
						# ea_non_mailing.entity_id = client.id
						# ea_non_mailing.address_id = non_mailing_address.id
						# ea_non_mailing.save!
					end
					if arg_address_struct.address_parameters[:notes].present? && arg_address_struct.can_save && arg_address_struct.entity_type != 6150
						# Notes Save for client is handled through contact service class
						NotesService.save_notes(arg_address_struct.entity_type, # entity_type = Client
		                            arg_address_struct.entity_obj.id, # entity_id = Client id
		                            6474,  # notes_type = client
		                            nil, # Ex: reference_id = income ID
		                            arg_address_struct.address_parameters[:notes]) # notes
					end
				end
			rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("AddressService","create",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to save address information - for more details refer to error ID: #{error_object.id}."
			end
			arg_address_struct.exception_msg = msg
		end
		arg_address_struct.addresses_error_messages_obj =  @addresses_error_messages unless arg_address_struct.can_save
		arg_address_struct.address_obj = @address unless arg_address_struct.can_save
		return arg_address_struct
	end

	def self.check_for_presence_of_mailing_address(arg_address)
		if ( arg_address[:in_care_of].present? ||
				arg_address[:address_line1].present? ||
				arg_address[:address_line2].present? ||
				arg_address[:city].present? ||
				arg_address[:state].present? ||
				arg_address[:zip].present? #||
				#arg_address[:zip_suffix].present? ||
				#arg_address[:county].present?
			   )
			return true
		else
			return false
		end
	end

	def self.check_for_presence_of_non_mailing_address(arg_address)
		if ( arg_address[:non_mailing_in_care_of].present? ||
				arg_address[:non_mailing_address_line1].present? ||
				arg_address[:non_mailing_address_line2].present? ||
				arg_address[:non_mailing_city].present? ||
				arg_address[:non_mailing_state].present? ||
				arg_address[:non_mailing_zip].present? #||
				#arg_address[:non_mailing_zip_suffix].present? ||
				#arg_address[:non_mailing_county].present?
			   )
			return true
		else
			return false
		end
	end

	def self.build_mailing_address_object(arg_address, arg_mailing_address, arg_entity_type)
		#arg_mailing_address = Address.new
		arg_mailing_address.in_care_of = arg_address[:in_care_of]
		arg_mailing_address.address_line1 = arg_address[:address_line1]
		arg_mailing_address.address_line2 = arg_address[:address_line2]
		arg_mailing_address.city = arg_address[:city]
		arg_mailing_address.state = arg_address[:state]
		arg_mailing_address.zip = arg_address[:zip]
		arg_mailing_address.zip_suffix = arg_address[:zip_suffix]
		# arg_mailing_address.county = arg_address[:county]
		arg_mailing_address.address_type = arg_address[:address_type]
		if arg_address[:effective_begin_date].present?
			arg_mailing_address.effective_begin_date = arg_address[:effective_begin_date]
		else
			arg_mailing_address.effective_begin_date = Date.today
		end
		# arg_mailing_address.verified = arg_address[:overwrite_mailing_address].present? ? arg_address[:overwrite_mailing_address] :'Y'
		if arg_entity_type == 6150
			usps_address = AddressService.initialize_with_verified_mailing_address(arg_address, Address.new)
			arg_mailing_address.verified = get_mailing_address_verified_flag(arg_mailing_address, usps_address)
		end
		return arg_mailing_address
	end

	def self.build_non_mailing_address_object(arg_address, arg_non_mailing_address, arg_entity_type)
		#arg_non_mailing_address = Address.new
		arg_non_mailing_address.in_care_of = arg_address[:non_mailing_in_care_of]
		arg_non_mailing_address.address_line1 = arg_address[:non_mailing_address_line1]
		arg_non_mailing_address.address_line2 = arg_address[:non_mailing_address_line2]
		arg_non_mailing_address.city = arg_address[:non_mailing_city]
		arg_non_mailing_address.state = arg_address[:non_mailing_state]
		arg_non_mailing_address.zip = arg_address[:non_mailing_zip]
		arg_non_mailing_address.zip_suffix = arg_address[:non_mailing_zip_suffix]
		# arg_non_mailing_address.county = arg_address[:non_mailing_county]
		arg_non_mailing_address.address_type = arg_address[:non_mailing_address_type]
		if arg_address[:effective_begin_date].present?
			arg_non_mailing_address.effective_begin_date = arg_address[:effective_begin_date]
			# Rails.logger.debug("arg_non_mailing_address.effective_begin_date = #{arg_non_mailing_address.effective_begin_date.inspect}")
		else
			arg_non_mailing_address.effective_begin_date = Date.today
		end
		arg_non_mailing_address.living_arrangement = arg_address[:living_arrangement]
		# arg_non_mailing_address.verified = arg_address[:overwrite_non_mailing_address].present? ? arg_address[:overwrite_non_mailing_address] :'Y'
		if arg_entity_type == 6150
			usps_address = AddressService.initialize_with_verified_mailing_address(arg_address, Address.new)
			arg_non_mailing_address.verified = get_non_mailing_address_verified_flag(arg_non_mailing_address, usps_address)
		end
		return arg_non_mailing_address
	end

	def self.validate_address_information(arg_address)
		unless arg_address.valid?
			arg_address.errors.full_messages.each do |msg|
				@addresses_error_messages.errors[:base] << CodetableItem.get_short_description(arg_address.address_type) + " Address " + msg
			end
		end
	end

	def self.update(arg_address_struct)
		msg = nil
		@address_parameters = arg_address_struct.address_parameters
		@addresses_error_messages = Address.new
		#@client = arg_address_struct.entity_obj
		addresses = Address.get_entity_addresses(arg_address_struct.entity_obj.id,arg_address_struct.entity_type)
		mailing_address_changed = false
		non_mailing_address_changed = false
		mailing_address_created_for_first_time = false
		non_mailing_address_created_for_first_time = false

		mailing_address = addresses.where("address_type = 4665")
		non_mailing_address = addresses.where("address_type = 4664")
		# Rails.logger.debug("mailing_address = #{mailing_address.inspect}")
		# Rails.logger.debug("non_mailing_address = #{non_mailing_address.inspect}")

		if mailing_address.present?

			mailing_address = mailing_address.first
			mailing_address_changed = is_there_a_change_in_mailing_address(mailing_address)
		else

			if check_for_presence_of_mailing_address(arg_address_struct.address_parameters)
				mailing_address_created_for_first_time = true
			end
		end
		# Rails.logger.debug("mailing_address_changed = #{mailing_address_changed.inspect}")



		if non_mailing_address.present?

			non_mailing_address = non_mailing_address.first

			non_mailing_address_changed = is_there_a_change_in_non_mailing_address(non_mailing_address,arg_address_struct)
		else

			if check_for_presence_of_non_mailing_address(arg_address_struct.address_parameters) || (@address_parameters[:non_mailing_addr_same_as_mailing] == "Y")
				non_mailing_address_created_for_first_time = true
			end
		end
		# Rails.logger.debug("non_mailing_address_changed = #{non_mailing_address_changed.inspect}")


		arg_address_struct.is_there_an_address_change = mailing_address_changed || non_mailing_address_changed
		# Rails.logger.debug("arg_address_struct.is_there_an_address_change = #{arg_address_struct.is_there_an_address_change.inspect}")
		notes_changes = is_create_or_update_required_on_notes(arg_address_struct)
		if arg_address_struct.is_there_an_address_change || mailing_address_created_for_first_time || non_mailing_address_created_for_first_time || notes_changes
			prior_address_flag = true
			if (!(arg_address_struct.is_there_an_address_change) && (mailing_address_created_for_first_time || non_mailing_address_created_for_first_time))
				prior_address_flag = true
			else
				if mailing_address_changed
					if arg_address_struct.entity_type == 6150
						@address_parameters[:save_prior_mailing_address] = "Y" if @address_parameters[:save_prior_mailing_address].blank?
					else
						unless  @address_parameters[:save_prior_mailing_address].present?
							prior_address_flag = false
							@addresses_error_messages.errors[:base] << "Do you want to save prior #{CodetableItem.get_short_description(arg_address_struct.address_parameters[:address_type])} address?"
						end
					end
				end
				if non_mailing_address_changed
					if arg_address_struct.entity_type == 6150
						@address_parameters[:save_prior_non_mailing_address] = "Y" if @address_parameters[:save_prior_non_mailing_address].blank?
					else
						unless  @address_parameters[:save_prior_non_mailing_address].present?
							prior_address_flag = false
							@addresses_error_messages.errors[:base] << "Do you want to save prior #{CodetableItem.get_short_description(arg_address_struct.address_parameters[:non_mailing_address_type])} address?"
						end
					end
				end
			end

			if prior_address_flag#@address_parameters[:save_prior_address].present? || (!(arg_address_struct.is_there_an_address_change) && (mailing_address_created_for_first_time || non_mailing_address_created_for_first_time))


				if mailing_address_changed || mailing_address_created_for_first_time
					if @address_parameters[:save_prior_mailing_address] == "Y" && !(mailing_address_created_for_first_time)
						mailing_address.address_type = arg_address_struct.prev_mailing_address_type#4666
						mailing_address.effective_end_date = Date.today
						new_mailing_address = Address.new
						new_mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type) #initialize_address_object_with_new_mailing_address(new_mailing_address)
						validate_address_information(new_mailing_address)
					else
						if mailing_address_created_for_first_time
							mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type) #initialize_address_object_with_new_mailing_address(mailing_address)
						else
							mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, mailing_address, arg_address_struct.entity_type) #initialize_address_object_with_new_mailing_address(mailing_address)
						end

                        # mailing_address.effective_begin_date =  Date.today
						validate_address_information(mailing_address)
					end
				end


				if non_mailing_address_created_for_first_time
					if @address_parameters[:non_mailing_addr_same_as_mailing] == "Y"
						non_mailing_address =  build_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type)
						non_mailing_address.address_type = arg_address_struct.address_parameters[:non_mailing_address_type]
					else
						non_mailing_address =  build_non_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type)#initialize_address_object_with_new_non_mailing_address(non_mailing_address)
					end
					validate_address_information(non_mailing_address)
				else
					if non_mailing_address_changed
						if @address_parameters[:save_prior_non_mailing_address] == "Y"
							non_mailing_address.address_type =  arg_address_struct.prev_non_mailing_address_type#5769
							new_non_mailing_address = Address.new
							if @address_parameters[:non_mailing_addr_same_as_mailing] == "Y"
								new_non_mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type)#initialize_address_object_with_new_mailing_address(new_non_mailing_address)
								new_non_mailing_address.address_type = arg_address_struct.address_parameters[:non_mailing_address_type]
							else
								new_non_mailing_address = build_non_mailing_address_object(arg_address_struct.address_parameters, new_non_mailing_address, arg_address_struct.entity_type)#initialize_address_object_with_new_non_mailing_address(new_non_mailing_address)
							end
							validate_address_information(new_non_mailing_address)
						else
							if @address_parameters[:non_mailing_addr_same_as_mailing] == "Y"
								non_mailing_address = build_mailing_address_object(arg_address_struct.address_parameters, non_mailing_address, arg_address_struct.entity_type)#initialize_address_object_with_new_mailing_address(non_mailing_address)
								non_mailing_address.address_type = arg_address_struct.address_parameters[:non_mailing_address_type]
							else
								non_mailing_address =  build_non_mailing_address_object(arg_address_struct.address_parameters, non_mailing_address, arg_address_struct.entity_type)#initialize_address_object_with_new_non_mailing_address(non_mailing_address)
							end
							validate_address_information(non_mailing_address)
						end
					end
				end


				if  @addresses_error_messages.errors.full_messages.present?
					if mailing_address_changed || mailing_address_created_for_first_time
						if @address_parameters[:save_prior_mailing_address] == "Y" && !(mailing_address_created_for_first_time)
							@address = new_mailing_address
						else
							@address = mailing_address
						end
						if non_mailing_address.present?
							populate_non_mailing_address_in_address_instance(non_mailing_address)
						end
					else
						@address = mailing_address.present? ? mailing_address : Address.new
					end
					if non_mailing_address_changed || non_mailing_address_created_for_first_time
						if @address_parameters[:save_prior_non_mailing_address] == "Y" && !(non_mailing_address_created_for_first_time)
							populate_non_mailing_address_in_address_instance(new_non_mailing_address)
						else
							populate_non_mailing_address_in_address_instance(non_mailing_address)
						end
					end
					@address.non_mailing_addr_same_as_mailing = @address_parameters["non_mailing_addr_same_as_mailing"]
					@address.save_prior_mailing_address = @address_parameters[:save_prior_mailing_address]
					@address.save_prior_non_mailing_address = @address_parameters[:save_prior_non_mailing_address]
				else
					begin
						ActiveRecord::Base.transaction do
							if mailing_address_created_for_first_time
								mailing_address.save! if arg_address_struct.can_save
								insert_into_entity_address(arg_address_struct, mailing_address)
								# ea_mailing = EntityAddress.new
								# ea_mailing.entity_type = arg_address_struct.entity_type
								# ea_mailing.entity_id = @client.id
								# ea_mailing.address_id = mailing_address.id
								# ea_mailing.save!
							else
								if mailing_address_changed
									if @address_parameters[:save_prior_mailing_address] == "Y"
										if arg_address_struct.entity_type == 6150 || arg_address_struct.entity_type == 6151 # "Client"
											msg = trigger_events_for_address_changes(arg_address_struct, new_mailing_address)
										end
										new_mailing_address.save! if arg_address_struct.can_save
										insert_into_entity_address(arg_address_struct, new_mailing_address)
										# ea_mailing = EntityAddress.new
										# ea_mailing.entity_type = arg_address_struct.entity_type
										# ea_mailing.entity_id = @client.id
										# ea_mailing.address_id = new_mailing_address.id
										# ea_mailing.save!
									else
										if arg_address_struct.entity_type == 6150 || arg_address_struct.entity_type == 6151 # "Client"
											msg = trigger_events_for_address_changes(arg_address_struct, mailing_address)
										end
									end
									mailing_address.save! if arg_address_struct.can_save
								end
							end



							if non_mailing_address_created_for_first_time
								non_mailing_address.client_id = arg_address_struct.client_id if arg_address_struct.entity_type == 6150
								non_mailing_address.save! if arg_address_struct.can_save
								insert_into_entity_address(arg_address_struct, non_mailing_address)
								# ea_mailing = EntityAddress.new
								# ea_mailing.entity_type = arg_address_struct.entity_type
								# ea_mailing.entity_id = @client.id
								# ea_mailing.address_id = non_mailing_address.id
								# ea_mailing.save!
							else
								if non_mailing_address_changed
									non_mailing_address.client_id = arg_address_struct.client_id if arg_address_struct.entity_type == 6150 && non_mailing_address.present?
									if @address_parameters[:save_prior_non_mailing_address] == "Y"
										new_non_mailing_address.client_id = arg_address_struct.client_id if arg_address_struct.entity_type == 6150
										if arg_address_struct.entity_type == 6150 || arg_address_struct.entity_type == 6151 # "Client"
											if msg.blank? || (msg.present? && msg == "SUCCESS")
												msg = trigger_events_for_address_changes(arg_address_struct, new_non_mailing_address)
											end
										end
										new_non_mailing_address.save! if arg_address_struct.can_save
										insert_into_entity_address(arg_address_struct, new_non_mailing_address)
										# ea_non_mailing = EntityAddress.new
										# ea_non_mailing.entity_type = arg_address_struct.entity_type
										# ea_non_mailing.entity_id = @client.id
										# ea_non_mailing.address_id = new_non_mailing_address.id
										# ea_non_mailing.save!
									else
										if arg_address_struct.entity_type == 6150 || arg_address_struct.entity_type == 6151 # "Client"
											if msg.blank? || (msg.present? && msg == "SUCCESS")
												msg = trigger_events_for_address_changes(arg_address_struct, non_mailing_address)
											end
										end
									end
									non_mailing_address.save! if arg_address_struct.can_save
								end
							end
							notes = NotesService.get_notes(arg_address_struct.entity_type,arg_address_struct.entity_obj.id,6474,nil)
							if (@address_parameters[:notes].present? && notes.present? && @address_parameters[:notes] != notes) ||
								(@address_parameters[:notes].present? && !(notes.present?))
								if arg_address_struct.can_save && arg_address_struct.entity_type != 6150
									# Notes Save for client is handled through contact service class
									NotesService.save_notes(arg_address_struct.entity_type, # entity_type = Client
		                                    arg_address_struct.entity_obj.id, # entity_id = Client id
		                                    6474,  # notes_type = client
		                                    nil, # Ex: reference_id = income ID
		                                    @address_parameters[:notes]) # notes
								end
							elsif @address_parameters[:notes].blank? && notes.present?
								# NotesService.delete_notes(arg_address_struct.entity_type,arg_address_struct.entity_obj.id,6474,nil)
							end
						end
					rescue => err
						error_object = CommonUtil.write_to_attop_error_log_table("AddressService","update",err,AuditModule.get_current_user.uid)
						msg = "Failed to save address information - for more details refer to error ID: #{error_object.id}."
					end

				end
			else
				#@addresses_error_messages.errors[:base] << "Do you want to save prior address?"
				@address = build_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type)
				non_mailing_address = build_non_mailing_address_object(arg_address_struct.address_parameters, Address.new, arg_address_struct.entity_type)
				populate_non_mailing_address_in_address_instance(non_mailing_address)
				@address.non_mailing_addr_same_as_mailing = @address_parameters[:non_mailing_addr_same_as_mailing]
				@address.address_type = @address_parameters[:address_type]
				@address.non_mailing_address_type = @address_parameters[:non_mailing_address_type]
				@address.save_prior_mailing_address = @address_parameters[:save_prior_mailing_address]
				@address.save_prior_non_mailing_address = @address_parameters[:save_prior_non_mailing_address]
			end

		end
		arg_address_struct.address_obj = @address
		arg_address_struct.addresses_error_messages_obj = @addresses_error_messages
		arg_address_struct.is_there_an_address_change = arg_address_struct.is_there_an_address_change || mailing_address_created_for_first_time || non_mailing_address_created_for_first_time
		if msg.present? && msg != "SUCCESS"
			arg_address_struct.exception_msg = msg
		end
		return arg_address_struct
	end

	def self.populate_non_mailing_address_in_address_instance(arg_address)
		@address.non_mailing_in_care_of = arg_address.in_care_of
		@address.non_mailing_address_line1 = arg_address.address_line1
		@address.non_mailing_address_line2 = arg_address.address_line2
		@address.non_mailing_city = arg_address.city
		@address.non_mailing_state = arg_address.state
		@address.non_mailing_zip = arg_address.zip
		@address.non_mailing_zip_suffix = arg_address.zip_suffix
		@address.effective_begin_date = arg_address.effective_begin_date
		@address.living_arrangement = arg_address.living_arrangement
		# @address.non_mailing_county = arg_address.county
		@address.non_mailing_address_type = arg_address.address_type
	end

	def self.validate_address_information(arg_address)
		# Rails.logger.debug("-->arg_address = #{arg_address.inspect}")
		unless arg_address.valid?
			arg_address.errors.full_messages.each do |msg|
				@addresses_error_messages.errors[:base] << CodetableItem.get_short_description(arg_address.address_type) + " Address " + msg
			end
		end
	end



	def self.is_there_a_change_in_mailing_address(arg_mailing_address)
		result = false
		if ( (@address_parameters[:in_care_of] != arg_mailing_address.in_care_of) ||
			 (@address_parameters[:address_line1] != arg_mailing_address.address_line1) ||
			 (@address_parameters[:address_line2] != arg_mailing_address.address_line2) ||
			 (@address_parameters[:city] != arg_mailing_address.city) ||
			 (@address_parameters[:state].to_i != arg_mailing_address.state) ||
			 (@address_parameters[:zip] != arg_mailing_address.zip) ||
			 (@address_parameters[:zip_suffix].to_i != arg_mailing_address.zip_suffix.to_i) # ||
			 # (@address_parameters[:county].present? ? (@address_parameters[:county].to_i != arg_mailing_address.county) : arg_mailing_address.county.present?)
		   )
	    	result = true
		end
		return result
	end

	def self.is_there_a_change_in_non_mailing_address(arg_non_mailing_address,arg_address_struct)
		result = false
		if @address_parameters[:non_mailing_addr_same_as_mailing] == "Y"

			if (
				(@address_parameters[:in_care_of] != arg_non_mailing_address.in_care_of) ||
				 (@address_parameters[:address_line1] != arg_non_mailing_address.address_line1) ||
				 (@address_parameters[:address_line2] != arg_non_mailing_address.address_line2) ||
				 (@address_parameters[:city] != arg_non_mailing_address.city) ||
				 (@address_parameters[:state].to_i != arg_non_mailing_address.state) ||
				 (@address_parameters[:zip] != arg_non_mailing_address.zip) ||
				 (@address_parameters[:zip_suffix].to_i != arg_non_mailing_address.zip_suffix.to_i) ||
				 (@address_parameters[:effective_begin_date].to_date != arg_non_mailing_address.effective_begin_date) ||
				 (@address_parameters[:living_arrangement] != arg_non_mailing_address.living_arrangement)

				 # (@address_parameters[:county].present? ? (@address_parameters[:county].to_i != arg_non_mailing_address.county) : arg_non_mailing_address.county.present?)
			   )
		    	result = true
			end
		else

			if @address_parameters[:non_mailing_address_line1].present? && @address_parameters[:non_mailing_city].present?

				if ( (@address_parameters[:non_mailing_in_care_of] != arg_non_mailing_address.in_care_of) ||
					 (@address_parameters[:non_mailing_address_line1] != arg_non_mailing_address.address_line1) ||
					 (@address_parameters[:non_mailing_address_line2] != arg_non_mailing_address.address_line2) ||
					 # (@address_parameters[:non_mailing_address_line2].present? ? (@address_parameters[:non_mailing_address_line2] != arg_non_mailing_address.address_line2) : arg_non_mailing_address.address_line2.present?) ||
					 (@address_parameters[:non_mailing_city] != arg_non_mailing_address.city) ||
					 (@address_parameters[:non_mailing_state].to_i != arg_non_mailing_address.state) ||
					 (@address_parameters[:non_mailing_zip] != arg_non_mailing_address.zip) ||
					 (@address_parameters[:non_mailing_zip_suffix].to_i != arg_non_mailing_address.zip_suffix.to_i) ||
					 ((@address_parameters[:effective_begin_date].to_date != arg_non_mailing_address.effective_begin_date) if arg_address_struct.entity_type == 6150)

					 # || (@address_parameters[:non_mailing_zip_suffix].present? ? (@address_parameters[:non_mailing_zip_suffix].to_i != arg_non_mailing_address.zip_suffix) : arg_non_mailing_address.zip_suffix.present?) #||
					 # (@address_parameters[:effective_begin_date].to_date != arg_non_mailing_address.effective_begin_date) ||
				     # (@address_parameters[:living_arrangement] != arg_non_mailing_address.living_arrangement)
					 # (@address_parameters[:non_mailing_county].present? ? (@address_parameters[:non_mailing_county].to_i != arg_non_mailing_address.county) : arg_non_mailing_address.county.present?)
				   )
					result = true
			    end
			end
		end
		return result
	end

	def self.insert_into_entity_address(arg_address_struct, arg_address_obj)
		ea_mailing = EntityAddress.new
		ea_mailing.entity_type = arg_address_struct.entity_type
		ea_mailing.entity_id = arg_address_struct.entity_obj.id
		ea_mailing.address_id = arg_address_obj.id
		ea_mailing.save! if arg_address_struct.can_save
	end

	def self.is_create_or_update_required_on_notes(arg_address_struct)
		result = false
		notes = NotesService.get_notes(arg_address_struct.entity_type,arg_address_struct.entity_obj.id,6474,nil)
		if (@address_parameters[:notes].present? && notes.blank?) || (@address_parameters[:notes].blank? && notes.present?) ||
			(@address_parameters[:notes].present? && notes.present? && (@address_parameters[:notes] != notes))
			result = true
		end
		return result
	end

	def self.trigger_events_for_address_changes(arg_address_struct, arg_address_object)
		arg_entity_object = arg_address_struct.entity_obj
		ls_msg = nil
		case arg_entity_object.class.name
		when "Client"
			if ProgramUnitParticipation.is_the_client_present_in_open_program_unit?(arg_entity_object.id) &&
									ProgramUnitRepresentative.is_representative_of_an_open_program_unit(arg_entity_object.id)
				# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
				common_action_argument_object.client_id = arg_entity_object.id
		        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_entity_object.id)
		        common_action_argument_object.model_object = arg_address_object
		        common_action_argument_object.address_type = arg_address_object.address_type
		        common_action_argument_object.entity_type = 6150 # "Client"
		        common_action_argument_object.changed_attributes = arg_address_object.changed_attributes().keys
		        common_action_argument_object.is_a_new_record = arg_address_object.new_record?
		        arg_address_object.save! if arg_address_struct.can_save
				ls_msg = EventManagementService.process_event(common_action_argument_object) if arg_address_struct.can_save
			else
				arg_address_object.save! if arg_address_struct.can_save
			end
		when "Provider"
			if arg_address_object.new_record?
				arg_address_object.save!
			elsif arg_address_object.address_type == 4665 # "Mailing Address"
				# step1 : Populate common event management argument structure
				common_action_argument_object = CommonEventManagementArgumentsStruct.new
				common_action_argument_object.provider_id = arg_entity_object.id
		        common_action_argument_object.model_object = arg_address_object
		        common_action_argument_object.address_type = arg_address_object.address_type
		        common_action_argument_object.entity_type = 6151 # "Provider"
		        common_action_argument_object.changed_attributes = arg_address_object.changed_attributes().keys
		        common_action_argument_object.is_a_new_record = arg_address_object.new_record?
		        arg_address_object.save!
				ls_msg = EventManagementService.process_event(common_action_argument_object)
			end
		end
        return ls_msg
	end

	def self.get_verified_mailing_address(address_params)
		usps_web_service = UspsWebServices.new
		usps_web_service.get_address_from_usps(address_params[:address_line1],address_params[:address_line2],address_params[:city],address_params[:state],address_params[:zip],address_params[:zip_suffix],options = {})
	end

	def self.get_verified_non_mailing_address(address_params)
		usps_web_service = UspsWebServices.new
		usps_web_service.get_address_from_usps(address_params[:non_mailing_address_line1],address_params[:non_mailing_address_line2],address_params[:non_mailing_city],address_params[:non_mailing_state],address_params[:non_mailing_zip],address_params[:non_mailing_zip_suffix],options = {})
	end

	def self.get_mailing_address_verified_flag(arg_address, arg_usps_address)
		return compare_mailing_address_with_usps_mailing_address(arg_address, arg_usps_address) ? "Y" : "N"
	end

	def self.get_non_mailing_address_verified_flag(arg_address, arg_usps_address)
		return compare_non_mailing_address_with_usps_non_mailing_address(arg_address, arg_usps_address) ? "Y" : "N"
	end

	def self.compare_mailing_address_with_usps_mailing_address(arg_address, arg_usps_address)
		result = true
		result = result && compare_fields(arg_address.address_line1, arg_usps_address.address_line1)
		result = result && compare_fields(arg_address.address_line2, arg_usps_address.address_line2)
		result = result && compare_fields(arg_address.city, arg_usps_address.city)
		result = result && compare_fields(arg_address.state, arg_usps_address.state)
		result = result && compare_fields(arg_address.zip, arg_usps_address.zip)
		# result = result && compare_fields(arg_address.zip_suffix, arg_usps_address.zip_suffix)
		return result
	end

	def self.compare_non_mailing_address_with_usps_non_mailing_address(arg_address, arg_usps_address)
		result = true
		result = result && compare_fields(arg_address.non_mailing_address_line1, arg_usps_address.non_mailing_address_line1)
		result = result && compare_fields(arg_address.non_mailing_address_line2, arg_usps_address.non_mailing_address_line2)
		result = result && compare_fields(arg_address.non_mailing_city, arg_usps_address.non_mailing_city)
		result = result && compare_fields(arg_address.non_mailing_state, arg_usps_address.non_mailing_state)
		result = result && compare_fields(arg_address.non_mailing_zip, arg_usps_address.non_mailing_zip)

		return result
	end

	def self.compare_fields(arg1, arg2)
		result = true
		if arg1.present?
			if arg2.present?
				result = false if arg1.to_s.upcase != arg2.to_s.upcase
			else
				result = false
			end
		else
			result = false if arg2.present?
		end
		return result
	end

	def self.initialize_with_verified_mailing_address(address_params, address_obj)
		mailing_address = AddressService.get_verified_mailing_address(address_params)
		city_and_state_hash = get_city_and_state_code_table_item_ids(mailing_address)
		if mailing_address["Error"].present? || city_and_state_hash.blank?
			address_obj.errors[:base] << "Address not verified. Please enter a valid Mailing address or overwrite"
			# @show_overwrite_button = true
			@address.overwrite_mailing_address = "N" if @address.present?
		else
			address_obj.in_care_of = address_params[:in_care_of]
			address_obj.address_line1 = mailing_address["Address2"]
			address_obj.address_line2 = mailing_address["Address1"] if mailing_address["Address1"].present?
			address_obj.city = mailing_address["City"].split.map(&:upcase).join(' ')
			address_obj.state = city_and_state_hash[:state]
			address_obj.zip = mailing_address["Zip_code"]
			address_obj.zip_suffix = mailing_address["Zip_suffix"]
		end
		return address_obj
	end

	def self.initialize_with_verified_non_mailing_address(address_params, address_obj)
		non_mailing_address = AddressService.get_verified_non_mailing_address(address_params)
		city_and_state_hash = get_city_and_state_code_table_item_ids(non_mailing_address)
		if non_mailing_address["Error"].present? || city_and_state_hash.blank?
			address_obj.errors[:base] << "Address not verified. Please enter a valid Physical address or overwrite"
			# @show_overwrite_button = true
			@address.overwrite_non_mailing_address = "N" if @address.present?
		else
			address_obj.non_mailing_in_care_of = address_params[:non_mailing_in_care_of]
			address_obj.non_mailing_address_line1 = non_mailing_address["Address2"]
			address_obj.non_mailing_address_line2 = non_mailing_address["Address1"] if non_mailing_address["Address1"].present?
			# address_obj.non_mailing_city = non_mailing_address["City"]
			# address_obj.non_mailing_state = non_mailing_address["State"]
			address_obj.non_mailing_city = non_mailing_address["City"].split.map(&:upcase).join(' ')
			# address_obj.non_mailing_city = city_and_state_hash[:city]
			address_obj.non_mailing_state = city_and_state_hash[:state]
			address_obj.non_mailing_zip = non_mailing_address["Zip_code"]
			address_obj.non_mailing_zip_suffix = non_mailing_address["Zip_suffix"]
		end
		return address_obj
	end

	def self.get_city_and_state_code_table_item_ids(arg_address_hash)
		result = nil
		if arg_address_hash["Error"].blank?
			result = CodetableItem.get_city_and_state_code_table_item_ids(arg_address_hash)
		end
		return result
	end


	def self.get_verified_address(address_params)
		usps_web_service = UspsWebServices.new
		usps_web_service.get_address_from_usps(address_params[:address_line1],address_params[:address_line2],address_params[:city],address_params[:state],address_params[:zip],address_params[:zip_suffix],options = {})
	end


	def self.initialize_with_verified_address(address_params, address_obj)
		address = AddressService.get_verified_address(address_params)
		city_and_state_hash = get_city_and_state_code_table_item_ids(address)
		if address["Error"].present? || city_and_state_hash.blank?
			address_obj.errors[:base] << "Address not verified. Please enter a valid address or overwrite"
			# @show_overwrite_button = true
			address_obj.overwrite_household_address = "N"
		else
			address_obj.in_care_of = address_params[:in_care_of]
			address_obj.address_line1 = address["Address2"]
			address_obj.address_line2 = address["Address1"] if address["Address1"].present?
			address_obj.city = address["City"].split.map(&:upcase).join(' ')
			address_obj.state = city_and_state_hash[:state]
			address_obj.zip = address["Zip_code"]
			address_obj.zip_suffix = address["Zip_suffix"]
		end
		return address_obj
	end


	def self.compare_address_with_usps_address(arg_address, arg_usps_address)
		result = true
		result = result && compare_fields(arg_address.address_line1, arg_usps_address.address_line1)
		result = result && compare_fields(arg_address.address_line2, arg_usps_address.address_line2)
		result = result && compare_fields(arg_address.city, arg_usps_address.city)
		result = result && compare_fields(arg_address.state, arg_usps_address.state)
		result = result && compare_fields(arg_address.zip, arg_usps_address.zip)
		# result = result && compare_fields(arg_address.zip_suffix, arg_usps_address.zip_suffix)
		return result
	end








end