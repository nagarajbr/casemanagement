class ContactsController < AttopAncestorController
	before_action :format_phone_params, only: [:create, :validate_address]

	def new
		if request.original_url.include? "clients/contacts"
			session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE] = nil
			session[:CALLED_FROM_ABSENT_PARENT_REGISTRATION_PAGE] = nil
		else
			session[:BACK_BUTTON_FROM_ADDRESS] = 'Y'
		end
		instances_for_contacts_page
		if (@address.new_non_mailing_address || session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE].present?)
			@css_id = "show_physical_address_fields"
			Rails.logger.debug("@css_id1 = #{@css_id.inspect}")
		else
			@css_id = "hide_physical_address_fields"
			Rails.logger.debug("@css_id2 = #{@css_id.inspect}")
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ContactsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error on new contact information."
		redirect_to_back
	end

	def validate_address
		if check_for_atleast_one_address_entry
			# fail
			address_struct = check_if_all_the_necessary_information_is_entered
			@addresses_error_messages = address_struct.addresses_error_messages_obj
			@address = Address.new
			# set_phone_and_email_attributes
			@address.assign_attributes(params_values)
			@address.valid?
			if @address.errors.full_messages.present?
				@address.errors.full_messages.each do |msg|
					@addresses_error_messages.errors[:base] << msg
				end
			end
			if @addresses_error_messages.present? && @addresses_error_messages.errors.full_messages.present?
				# fail
				@address.new_mailing_address = false
				@address.new_non_mailing_address = false
				set_physical_address_to_mailing_address_if_required
				@address.address_type = 4665
				@address.non_mailing_address_type = 4664
				render :new
			else
				@address = Address.new
				validate_address_and_redirect_to_confirmation_page
			end
		else
			flash.now[:notice] = "Please provide atleast one address."
			instances_for_contacts_page
			@address.new_mailing_address = false
			@address.new_non_mailing_address = false
	 		render :new
		end
	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ContactsController","validate_address",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error while validating address."
	 	redirect_to_back
	end

	def create
		# fail
		@address = Address.new
		call_appropriate_save_method
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ContactsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving contact information."
		redirect_to_back
	end

	def show
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			@client_email = ClientEmail.get_email_address(session[:CLIENT_ID])

			# only current Mailing and residence address are shown.
			@addresses = Address.get_entity_addresses(@client.id,6150)#@client.addresses.where("address_type in (4665,4664)").order(address_type: :desc)
			@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6474,nil)
			if @notes.present?
				l_records_per_page = SystemParam.get_pagination_records_per_page
	        	@notes = @notes.page(params[:page]).per(l_records_per_page)
			end
			set_phone_numbers
			@show_edit = @addresses.present? || @primary_phone.present? || @secondary_phone.present? || @other_phone.present? || @notes.present? || @client_email.present?
			 worker = ClientEmail.get_last_modified_user_id(session[:CLIENT_ID])
			 @modified_by = worker.present? ? worker.updated_by : nil
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ContactsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client address."
		redirect_to_back
	end

	private

		def instances_for_new
			@client = Client.find(session[:CLIENT_ID])
			@address =  Address.new
			@address.address_type = 4665
			#defaulted to AR
			@address.state = 5793

			@address.non_mailing_address_type = 4664
			@address.non_mailing_addr_same_as_mailing = "N"
			@address.new_mailing_address = true
			@address.new_non_mailing_address = true
		end

		def instances_for_edit
			# # fail
			# Rails.logger.debug("session*** = #{(session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE].present?).inspect}")
			# Rails.logger.debug("session*** = #{(session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE]).inspect}")
			# fail
			@client = Client.find(session[:CLIENT_ID])
			@client_email = ClientEmail.get_email_address(session[:CLIENT_ID])
			addresses = Address.get_entity_addresses(@client.id,6150)#@client.addresses.where("address_type = 4665").first
			mailing_address = addresses.where("address_type = 4665")
			if mailing_address.present?
				@address = mailing_address.first
			else
				@address =  Address.new
				@address.address_type = 4665
				@address.new_mailing_address = true
			end
			residence_address = addresses.where("address_type = 4664")
			if residence_address.present?
				residence_address = residence_address.first
				populate_residence_address_in_address_instance(residence_address)
			else
				@address.non_mailing_address_type = 4664
				@address.new_non_mailing_address = true
			end
			@address.non_mailing_addr_same_as_mailing = "N"
			if @address.address_line1? || @address.non_mailing_address_line1?
				@address.new_non_mailing_address = false
			else
				@address.new_non_mailing_address = true
			end
			# notes_obj = nil #NotesService.get_notes(6150,session[:CLIENT_ID],6474,nil)
			@address.notes = nil
			# primary_contact = PrimaryContact.get_primary_contact_for_household(session[:HOUSEHOLD_ID])
			# if primary_contact.present? && primary_contact.client_id == session[:CLIENT_ID]
			# 	@address.primary_contact = "Y"
			# else
			# 	@address.primary_contact = "N"
			# end
			set_phone_numbers
		end

		def instances_for_contacts_page
			addresses = Address.get_entity_addresses(session[:CLIENT_ID],6150)
			if addresses.present?
				instances_for_edit
			else
				instances_for_new
			end
		end

		def params_values
		  	params.require(:address).permit(:in_care_of,:address_line1,:address_line2,:city,:state,:zip,
		  		:zip_suffix,:address_type,:save_prior_mailing_address,:non_mailing_addr_same_as_mailing,:non_mailing_in_care_of,:non_mailing_address_line1,
		  		:non_mailing_address_line2,:non_mailing_city,:non_mailing_state,:non_mailing_zip,:non_mailing_zip_suffix,:effective_begin_date,
		  		:living_arrangement,:non_mailing_address_type,:save_prior_non_mailing_address,:primary,:secondary,:other,:email_address, :notes,
		  		:overwrite_mailing_address,:overwrite_non_mailing_address)
		end

		def phone_params_values
		  	params.require(:address).permit(:primary,:secondary,:other,:email_address,:notes)
	  	end

	  	def format_phone_params
	  		params[:address][:primary] = params[:address][:primary].scan(/\d/).join if params[:address][:primary].present?

		  	params[:address][:secondary] = params[:address][:secondary].scan(/\d/).join if params[:address][:secondary].present?

		  	params[:address][:other] = params[:address][:other].scan(/\d/).join if params[:address][:other].present?
		end

		def check_for_atleast_one_address_entry
	  		return check_for_presence_of_mailing_address || check_for_presence_of_non_mailing_address
	    end

		def check_for_presence_of_mailing_address
			if ( params[:address][:in_care_of].present? ||
					params[:address][:address_line1].present? ||
					#params[:address][:address_line2].present? ||
					params[:address][:city].present? ||
					#params[:address][:state].present? ||
					params[:address][:zip].present? #||

				   )
				return true
			else
				return false
			end
		end

		def check_for_presence_of_non_mailing_address
			if ( params[:address][:non_mailing_in_care_of].present? ||
					params[:address][:non_mailing_address_line1].present? ||
					#params[:address][:non_mailing_address_line2].present? ||
					params[:address][:non_mailing_city].present? ||
					#params[:address][:non_mailing_state].present? ||
					params[:address][:non_mailing_zip].present? #||

				   )
				return true
			else
				return false
			end
		end

		def all_required_overwrite_flags_are_selected
			result = true
			if params[:address][:required_mailing_address_confirmation].present? && params[:address][:required_mailing_address_confirmation].to_s == "true"
				if params[:address][:overwrite_mailing_address].blank?
					@address.errors[:base] << "Do you wish to overwrite Mailing Address"
					result = false
				else
					mailing_address = AddressService.get_verified_mailing_address(params[:address])
					if mailing_address["Error"].present? && params[:address][:overwrite_mailing_address].present? && params[:address][:overwrite_mailing_address] == "Y"
						@address.errors[:base] << "Mailing Address not verified and can't overwrite"
						result = false
					end
				end
			# else
			# 	if params[:address][:overwrite_mailing_address].present? && params[:address][:overwrite_mailing_address] == "Y"
			# 		@address.errors[:base] << "Mailing Address not verified and can't overwrite"
			# 		result = false
			# 	end
			end

			if params[:address][:required_non_mailing_address_confirmation].present? && params[:address][:required_non_mailing_address_confirmation].to_s == "true"
				if params[:address][:overwrite_non_mailing_address].blank?
					@address.errors[:base] << "Do you wish to overwrite Physical Address"
					result = false
				else
					non_mailing_address = AddressService.get_verified_non_mailing_address(params[:address])
					if non_mailing_address["Error"].present? && params[:address][:overwrite_non_mailing_address].present? && params[:address][:overwrite_non_mailing_address] == "Y"
						@address.errors[:base] << "Physical Address not verified and can't overwrite."
						result = false
					end
				end
			# else
			# 	if params[:address][:overwrite_non_mailing_address].present? && params[:address][:overwrite_non_mailing_address] == "Y"
			# 		@address.errors[:base] << "Physical Address not verified and can't overwrite."
			# 		result = false
			# 	end
			end
			return result
		end

		def populate_residence_address_in_address_instance(arg_address)
			@address.non_mailing_in_care_of = arg_address.in_care_of
			@address.non_mailing_address_line1 = arg_address.address_line1
			@address.non_mailing_address_line2 = arg_address.address_line2
			@address.non_mailing_city = arg_address.city
			@address.non_mailing_state = arg_address.state
			@address.non_mailing_zip = arg_address.zip
			@address.non_mailing_zip_suffix = arg_address.zip_suffix
			@address.non_mailing_county = arg_address.county
			@address.non_mailing_address_type = arg_address.address_type
			@address.effective_begin_date = arg_address.effective_begin_date
			@address.living_arrangement = arg_address.living_arrangement
		end

		def set_phone_numbers
			if session[:CLIENT_ID].present?
				phones = Phone.get_entity_contact_list(session[:CLIENT_ID], 6150)
				primary_phone = phones.where("phone_type = 4661")
				secondary_phone = phones.where("phone_type = 4662")
				other_phone = phones.where("phone_type = 4663")
				if @address.present?
					@address.email_address = @client_email if @client_email.present?
					@address.primary = primary_phone.first.phone_number if primary_phone.present?
					@address.secondary = secondary_phone.first.phone_number if secondary_phone.present?
					@address.other = other_phone.first.phone_number if other_phone.present?
				else

					@primary_phone = primary_phone.first if primary_phone.present?
					@secondary_phone = secondary_phone.first if secondary_phone.present?
					@other_phone = other_phone.first if other_phone.present?
					# find the last updated by record for client.
					phone_collection = EntityPhone.where("entity_type = 6150 and entity_id = ?", @client.id).order("updated_at DESC")
					# @modified_by = nil
					# if phone_collection.present? or @email.present? or @address.presen
					# 	latest_phone_object = phone_collection.first
					# 	@modified_by = latest_phone_object.updated_by
					# end
				end
			end
		end

		def set_phone_and_email_attributes
			phone_params = phone_params_values
			@address.primary = phone_params[:primary] if phone_params[:primary].present?
			@address.secondary = phone_params[:secondary] if phone_params[:secondary].present?
			@address.other = phone_params[:other] if phone_params[:other].present?
			@address.email_address = phone_params[:email_address] if phone_params[:email_address].present?
		end

		# def compare_mailing_address_with_usps_mailing_address
		# 	result = true
		# 	result = result && compare_fields(@address.address_line1, @usps_address.address_line1)
		# 	result = result && compare_fields(@address.address_line2, @usps_address.address_line2)
		# 	result = result && compare_fields(@address.city, @usps_address.city)
		# 	result = result && compare_fields(@address.state, @usps_address.state)
		# 	result = result && compare_fields(@address.zip, @usps_address.zip)
		# 	result = result && compare_fields(@address.zip_suffix, @usps_address.zip_suffix)
		# 	# if ( (@address.address_line1 != @usps_address.address_line1) &&
		# 	# 	 (@address.address_line2 != @usps_address.address_line2) &&
		# 	# 	 (@address.city != @usps_address.city) &&
		# 	# 	 (@address.state.to_i != @usps_address.state) &&
		# 	# 	 (@address.zip != @usps_address.zip) &&
		# 	# 	 (@address.zip_suffix != @usps_address.zip_suffix)
		# 	#    )
		# 	#    result = true
		# 	# end
		# 	# Rails.logger.debug("@address = #{@address.inspect}")
		# 	# Rails.logger.debug("@usps_address = #{@usps_address.inspect}")
		# 	# Rails.logger.debug("#{compare_fields(@address.address_line1, @usps_address.address_line1)}")
		# 	# Rails.logger.debug("compare_fields(@address.address_line2, @usps_address.address_line2) = #{compare_fields(@address.address_line2, @usps_address.address_line2)}")
		# 	# Rails.logger.debug("compare_fields(@address.city, @usps_address.city)= #{compare_fields(@address.city, @usps_address.city)}")
		# 	# Rails.logger.debug("compare_fields(@address.state, @usps_address.state) = #{compare_fields(@address.state, @usps_address.state)}")
		# 	# Rails.logger.debug("compare_fields(@address.zip, @usps_address.zip) = #{compare_fields(@address.zip, @usps_address.zip)}")
		# 	# Rails.logger.debug("compare_fields(@address.zip_suffix, @usps_address.zip_suffix) = #{compare_fields(@address.zip_suffix, @usps_address.zip_suffix)}")
		# 	# Rails.logger.debug("result = #{result}")
		# 	# fail
		# 	return !(result)

		# end

		# def compare_non_mailing_address_with_usps_non_mailing_address
		# 	result = true
		# 	result = result && compare_fields(@address.non_mailing_address_line1, @usps_address.non_mailing_address_line1)
		# 	result = result && compare_fields(@address.non_mailing_address_line2, @usps_address.non_mailing_address_line2)
		# 	result = result && compare_fields(@address.non_mailing_city, @usps_address.non_mailing_city)
		# 	result = result && compare_fields(@address.non_mailing_state, @usps_address.non_mailing_state)
		# 	result = result && compare_fields(@address.non_mailing_zip, @usps_address.non_mailing_zip)
		# 	result = result && compare_fields(@address.non_mailing_zip_suffix, @usps_address.non_mailing_zip_suffix)
		# 	# if ( (@address.address_line1 != @usps_address.address_line1) &&
		# 	# 	 (@address.address_line2 != @usps_address.address_line2) &&
		# 	# 	 (@address.city != @usps_address.city) &&
		# 	# 	 (@address.state.to_i != @usps_address.state) &&
		# 	# 	 (@address.zip != @usps_address.zip) &&
		# 	# 	 (@address.zip_suffix != @usps_address.zip_suffix)
		# 	#    )
		# 	#    result = true
		# 	# end
		# 	# Rails.logger.debug("@address = #{@address.inspect}")
		# 	# Rails.logger.debug("@usps_address = #{@usps_address.inspect}")
		# 	# Rails.logger.debug("#{compare_fields(@address.non_mailing_address_line1, @usps_address.non_mailing_address_line1)}")
		# 	# Rails.logger.debug("compare_fields(@address.non_mailing_address_line2, @usps_address.non_mailing_address_line2) = #{compare_fields(@address.non_mailing_address_line2, @usps_address.non_mailing_address_line2)}")
		# 	# Rails.logger.debug("compare_fields(@address.non_mailing_city, @usps_address.city)= #{compare_fields(@address.non_mailing_city, @usps_address.non_mailing_city)}")
		# 	# Rails.logger.debug("compare_fields(@address.non_mailing_state, @usps_address.non_mailing_state) = #{compare_fields(@address.non_mailing_state, @usps_address.non_mailing_state)}")
		# 	# Rails.logger.debug("compare_fields(@address.non_mailing_zip, @usps_address.non_mailing_zip) = #{compare_fields(@address.non_mailing_zip, @usps_address.non_mailing_zip)}")
		# 	# Rails.logger.debug("compare_fields(@address.non_mailing_zip_suffix, @usps_address.non_mailing_zip_suffix) = #{compare_fields(@address.non_mailing_zip_suffix, @usps_address.non_mailing_zip_suffix)}")
		# 	# Rails.logger.debug("result = #{result}")
		# 	# fail
		# 	return !(result)
		# end

		# def compare_fields(arg1, arg2)
		# 	result = true
		# 	if arg1.present?
		# 		if arg2.present?
		# 			if arg1.to_s.upcase != arg2.to_s.upcase
		# 				result = false
		# 			end
		# 		else
		# 			result = false
		# 		end
		# 	else
		# 		if arg2.present?
		# 			result = false
		# 		end
		# 	end
		# 	return result
		# end

		def validate_address_and_redirect_to_confirmation_page
			# fail
			@address.address_type = 4665
			@address.non_mailing_address_type = 4664
			set_physical_address_to_mailing_address_if_required
			@address.assign_attributes(params_values)
			set_phone_and_email_attributes

			@usps_address = Address.new
			@usps_address.address_type = 4665
			@usps_address.non_mailing_address_type = 4664
			address_params = params[:address]

			@usps_address = AddressService.initialize_with_verified_mailing_address(address_params, @usps_address)
			@usps_address = AddressService.initialize_with_verified_non_mailing_address(address_params, @usps_address)

			@address.effective_begin_date = address_params[:effective_begin_date] if address_params[:effective_begin_date].present?
			@address.living_arrangement = address_params[:living_arrangement] if address_params[:living_arrangement].present?

			# Rails.logger.debug("#{@address.non_mailing_city}")
			# Rails.logger.debug("#{@usps_address.non_mailing_city}")
			# Rails.logger.debug("compare_mailing_address_with_usps_mailing_address = #{compare_mailing_address_with_usps_mailing_address}")
			# Rails.logger.debug("compare_non_mailing_address_with_usps_non_mailing_address = #{compare_non_mailing_address_with_usps_non_mailing_address}")
			# fail
			if @address.city?
				@address.required_mailing_address_confirmation = !(AddressService.compare_mailing_address_with_usps_mailing_address(@address, @usps_address))
			end
			if @address.non_mailing_city.present?
				@address.required_non_mailing_address_confirmation = !(AddressService.compare_non_mailing_address_with_usps_non_mailing_address(@address, @usps_address))
			end

			if @address.required_mailing_address_confirmation || @address.required_non_mailing_address_confirmation
				render 'contacts/confirm_contact_information'
			else
				# addresses = Address.get_entity_addresses(@client.id,6150)#@client.addresses.where("address_type = 4665").first
				# mailing_address = addresses.where("address_type = 4665")
				# physical_address = addresses.where("address_type = 4664")

				# address_struct = call_appropriate_save_method if any_one_of_the_address_is_not_saved(mailing_address, physical_address)

				# @client_email = ClientEmail.get_email_address(session[:CLIENT_ID])
				# # set_phone_and_email_attributes
				# result_hash = ContactService.update(phone_params_values, @client, 6150,@client_email)
				# @address.errors[:base] << result_hash[:exception_msg] if result_hash[:exception_msg].present?
				# if session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE].present? && session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE] == 'Y'
				# 	# Navigate to address step.
				# 	# Rule: New Address is needed only for the first client when household will be created.
				# 	#  only other way to add client is by adding household member - which is done after creating household.
				# 	# that means that member belongs to current household.
				# 	session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_address_step"
				# 	session[:HOUSEHOLD_ID] = 0
				# 	redirect_to start_household_member_registration_wizard_path
				# else
				# 	redirect_to show_contact_information_path
				# end
				call_appropriate_save_method
			end
			# fail
			# if @usps_address.errors.full_messages.present?
			# 	render :new
			# else
			# 	render :confirm_contact_information
			# end
			# render :confirm_contact_information

		end

		def check_if_all_the_necessary_information_is_entered
			@client = Client.find(session[:CLIENT_ID])
			address_struct = AddressStruct.new
			address_struct.can_save = false
			address_struct.address_parameters = params[:address]
			address_struct.entity_obj = @client
			address_struct.entity_type = 6150
			addresses = Address.get_entity_addresses(session[:CLIENT_ID],6150)
			if addresses.present?
				address_struct.prev_mailing_address_type = 4666
				address_struct.prev_non_mailing_address_type = 5769
				address_struct = AddressService.update(address_struct)
			else
				address_struct = AddressService.create(address_struct)
			end

			# if params[:address][:primary_contact].blank?
			# 	address_struct.addresses_error_messages_obj.errors[:primary_contact] << "is required"
			# end
			return address_struct
		end

		def overwrite_address_params_with_verified_address_if_required
			if params[:address][:required_mailing_address_confirmation].present? && params[:address][:required_mailing_address_confirmation]
				if params[:address][:overwrite_mailing_address].present? && params[:address][:overwrite_mailing_address] == "Y"
					mailing_address = AddressService.get_verified_mailing_address(params[:address])
					# Rails.logger.debug("mailing_address = #{mailing_address.inspect}")
					# if mailing_address.present? && mailing_address.class.name != "String"
					unless mailing_address.keys.include?("Error")
						city_and_state_hash = AddressService.get_city_and_state_code_table_item_ids(mailing_address)
						params[:address][:address_line1] = mailing_address["Address2"]
						params[:address][:address_line2] = mailing_address["Address1"].present? ? mailing_address["Address1"] : ""
						params[:address][:city] = mailing_address["City"].split.map(&:capitalize).join(' ')# Code table equivalent
						params[:address][:state] = city_and_state_hash[:state] # Code table equivalent
						params[:address][:zip] = mailing_address["Zip_code"]
						params[:address][:zip_suffix] = mailing_address["Zip_suffix"]
					end
				end
			end

			if params[:address][:required_non_mailing_address_confirmation].present? && params[:address][:required_non_mailing_address_confirmation]
				if params[:address][:overwrite_non_mailing_address].present? && params[:address][:overwrite_non_mailing_address] == "Y"
					non_mailing_address = AddressService.get_verified_non_mailing_address(params[:address])
					if non_mailing_address.present? && non_mailing_address.class.name != "String"
						city_and_state_hash = AddressService.get_city_and_state_code_table_item_ids(non_mailing_address)
						params[:address][:non_mailing_address_line1] = non_mailing_address["Address2"]
						params[:address][:non_mailing_address_line2] = non_mailing_address["Address1"].present? ? non_mailing_address["Address1"] : ""
						params[:address][:non_mailing_city] = non_mailing_address["City"].split.map(&:capitalize).join(' ') # Code table equivalent
						params[:address][:non_mailing_state] = city_and_state_hash[:state] # Code table equivalent
						params[:address][:non_mailing_zip] = non_mailing_address["Zip_code"]
						params[:address][:non_mailing_zip_suffix] = non_mailing_address["Zip_suffix"]
					end
				end
			end
		end

		def set_physical_address_to_mailing_address_if_required
			# non_mailing_addr_same_as_mailing = params[:address][:non_mailing_addr_same_as_mailing]
			# if non_mailing_addr_same_as_mailing.present? && non_mailing_addr_same_as_mailing == "Y"
			# 	@address.non_mailing_address_line1 = @address.address_line1
			# 	@address.non_mailing_address_line2 = @address.address_line2
			# 	@address.non_mailing_city = @address.city
			# 	@address.non_mailing_state = @address.state
			# 	@address.non_mailing_zip = @address.zip
			# 	@address.non_mailing_zip_suffix = @address.zip_suffix
			# end
			non_mailing_addr_same_as_mailing = params[:address][:non_mailing_addr_same_as_mailing]
			if non_mailing_addr_same_as_mailing.present? && non_mailing_addr_same_as_mailing == "Y"
				params[:address][:non_mailing_address_line1] = params[:address][:address_line1]
				params[:address][:non_mailing_address_line2] = params[:address][:address_line2]
				params[:address][:non_mailing_city] = params[:address][:city]
				params[:address][:non_mailing_state] = params[:address][:state]
				params[:address][:non_mailing_zip] = params[:address][:zip]
				params[:address][:non_mailing_zip_suffix] = params[:address][:zip_suffix]
			end
		end

		def call_appropriate_save_method
			if all_required_overwrite_flags_are_selected
				@client = Client.find(session[:CLIENT_ID])

				address_struct = AddressStruct.new
				address_struct.can_save = true
				overwrite_address_params_with_verified_address_if_required
				address_struct.address_parameters = params[:address]
				address_struct.entity_obj = @client
				address_struct.entity_type = 6150
				addresses = Address.get_entity_addresses(session[:CLIENT_ID],6150)
				address_struct.client_id = @client.id
				if addresses.present?
					address_struct.prev_mailing_address_type = 4666
					address_struct.prev_non_mailing_address_type = 5769
					address_struct = AddressService.update(address_struct)
				else
					address_struct = AddressService.create(address_struct)
				end

				@addresses_error_messages = address_struct.addresses_error_messages_obj
				@address = address_struct.address_obj
				phone_params = phone_params_values
				@client_email = ClientEmail.where("client_id = ?",session[:CLIENT_ID] ).first
				result_hash = ContactService.update(phone_params_values, @client, 6150,@client_email)
				@phones_error_messages = result_hash[:errors_object]
				if (@addresses_error_messages.present? && @addresses_error_messages.errors.full_messages.present?) || @phones_error_messages.errors.full_messages.present?
					@address.new_non_mailing_address = true
					# if params[:address][:notes].present?
					# 	@address.notes = params[:address][:notes]
					# end
					# @address.assign_attributes(params)
					if result_hash[:exception_msg].present?
						@address.errors[:base] << result_hash[:exception_msg]
					end
					set_phone_and_email_attributes
					# @address.notes = phone_params[:notes] if phone_params[:notes].present?
					@address.new_mailing_address = false
					@address.new_non_mailing_address = false
					render :new
				else
					if session[:NAVIGATE_FROM].blank?
						if address_struct.exception_msg.present?
							flash[:notice] = address_struct.exception_msg
						# else
						# 	PrimaryContactService.save_primary_contact(session[:HOUSEHOLD_ID], 6744, session[:CLIENT_ID]) if params[:address][:primary_contact] == "Y"
						# 	flash[:notice] = "Contact information saved "
						end
						# Manoj 01/25/2016 - calling contacts controller from HH resgistration step
						if session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE].present? && session[:CALLED_FROM_HOUSEHOLD_REGISTRATION_PAGE] == 'Y'
							# Navigate to address step.
							# Rule: New Address is needed only for the first client when household will be created.
							#  only other way to add client is by adding household member - which is done after creating household.
							# that means that member belongs to current household.
							session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] == "household_member_address_step"
							session[:HOUSEHOLD_ID] = 0
							redirect_to start_household_member_registration_wizard_path
						elsif session[:CALLED_FROM_ABSENT_PARENT_REGISTRATION_PAGE].present? && session[:CALLED_FROM_ABSENT_PARENT_REGISTRATION_PAGE] == 'Y'
							session[:ABSENT_PARENT_STEP] == "household_absent_parent_address_step"
							redirect_to start_household_absent_parents_wizard_path
						else
							redirect_to show_contact_information_path
						end

					else
						# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
						if address_struct.exception_msg.present?
							flash[:notice] = address_struct.exception_msg
						end
		  				navigate_back_to_called_page()
					end
				end
			else
				@mailing_address_changed = params[:address][:required_mailing_address_confirmation].present?
				@physical_address_changed = params[:address][:required_non_mailing_address_confirmation].present?
				validate_address_and_redirect_to_confirmation_page
			end
		end

		# def any_one_of_the_address_is_not_saved(mailing_address, physical_address)
		# 	result = mailing_address.blank? && params[:address][:address_line1].present? || physical_address.blank? && params[:address][:non_mailing_address_line1].present?
		# end
end