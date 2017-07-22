class AddressesController < AttopAncestorController
	before_action :default_state_to_arkansas, only: [:create,:update]


	def new
		@entity_type = 6150
		initialize_instance_objects_for_new_page()
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","new",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when creating new Address."
			redirect_to_back
	end

	def create
		@entity_type = 6150
		if check_for_atleast_one_address_entry
			address_struct = AddressStruct.new
			address_struct.address_parameters = params[:address]
			@client = Client.find(session[:CLIENT_ID])
			address_struct.entity_obj = @client
			address_struct.entity_type = 6150
			address_struct.can_save = true
			address_struct = AddressService.create(address_struct)
			#@client = address_struct.entity_obj
			@addresses_error_messages = address_struct.addresses_error_messages_obj
			@address = address_struct.address_obj

			if @addresses_error_messages.present? && @addresses_error_messages.errors.full_messages.present?
				@address.new_non_mailing_address = true
				if params[:address][:notes].present?
					@address.notes = params[:address][:notes]
				end
				render :new
			else
				if session[:NAVIGATE_FROM].blank?
					if address_struct.exception_msg.present?
						flash[:notice] = address_struct.exception_msg
					else
						flash[:notice] = "Address information saved."
					end
					redirect_to show_address_url
				else
					# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
					if address_struct.exception_msg.present?
						flash[:notice] = address_struct.exception_msg
					end
	  				navigate_back_to_called_page()
				end
			end
		else
			flash.now[:notice] = "Please provide atleast one address."
			initialize_instance_objects_for_new_page()
	 		render :new
		end

		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when saving address."
			redirect_to_back

	end



	def show
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			# only current Mailing and residence address are shown.
			@addresses = Address.get_entity_addresses(@client.id,6150)#@client.addresses.where("address_type in (4665,4664)").order(address_type: :desc)
			@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6474,nil)
		end

		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client address."
			redirect_to_back
	end

	def edit
		@entity_type = 6150
		@client = Client.find(session[:CLIENT_ID])
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
		@address.notes = NotesService.get_notes(6150,session[:CLIENT_ID],6474,nil)
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","edit",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when editing address."
			redirect_to_back
	end

	def update
		@entity_type = 6150
        address_struct = AddressStruct.new
		address_struct.address_parameters = params[:address]
		address_struct.entity_obj = Client.find(session[:CLIENT_ID])
		address_struct.entity_type = 6150
		address_struct.prev_mailing_address_type = 4666
		address_struct.prev_non_mailing_address_type = 5769
		address_struct.can_save = true
		address_struct = AddressService.update(address_struct)
		@client = address_struct.entity_obj
		@addresses_error_messages = address_struct.addresses_error_messages_obj
		@address = address_struct.address_obj

		if address_struct.is_there_an_address_change
			if  @addresses_error_messages.errors.full_messages.present?
				if params[:address][:notes].present?
					@address.notes = params[:address][:notes]
				end
				render :edit
			else
				if session[:NAVIGATE_FROM].blank?
					if address_struct.exception_msg.present?
						flash[:notice] = address_struct.exception_msg
					else
						flash[:notice] = "Address information saved."
					end
					redirect_to show_address_path
				else
					# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
					if address_struct.exception_msg.present?
						flash[:notice] = address_struct.exception_msg
					end
	  				navigate_back_to_called_page()
				end

			end
		else
			redirect_to show_address_url, notice: "No change in address."
		end


		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","update",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when updating address."
			redirect_to_back
	end



	def living_arrangement
		if params[:type] == "application"
			# @primary_applicant = ApplicationMember.get_primary_applicant(params[:id])
			@primary_applicant = PrimaryContact.get_primary_contact(params[:id], 6587)
		else
			# @primary_applicant = ProgramUnitMember.get_primary_beneficiary(params[:id])
			@primary_applicant = PrimaryContact.get_primary_contact(params[:id], 6345)
		end
		@primary_applicant = Client.find(@primary_applicant.client_id) if @primary_applicant.present?
		@primary_applicant_address = Address.get_non_mailing_address(@primary_applicant.id, 6150).first#@primary_applicant.addresses.where("address_type = 4664").first
		#Rails.logger.debug("Kiran = #{@primary_applicant_address.inspect}")
		@client = Client.find(session[:CLIENT_ID])
		@address = Address.get_non_mailing_address(@client.id, 6150)
		if @address.present?
			@address = @address.first#@client.addresses.where("address_type = 4664").first
		else
			@address = Address.new
			@address.address_type = 4664
		end
		@residence_address = @address#@client.addresses.where("address_type = 4664").first
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","living_arrangement",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occured while creating address."
			redirect_to_back
	end

	def update_living_arrangement
		if params[:address][:address_line1].present?
			client = Client.find(session[:CLIENT_ID])
			residence_address = Address.new
			residence_address.address_type = 4664
			residence_address.address_line1 = params[:address][:address_line1]
			residence_address.address_line2 = params[:address][:address_line2]
			residence_address.city = params[:address][:city]
			residence_address.state = params[:address_state]
			residence_address.zip = params[:address][:zip]
			residence_address.zip_suffix = params[:address][:zip_suffix]
			residence_address.county = params[:address_county]
			residence_address.client_id = client.id

			# This function show mailing but it's the address record for physical address so we have to use mailing methods only
			usps_address = AddressService.initialize_with_verified_mailing_address(params[:address], Address.new)
			residence_address.verified = AddressService.get_mailing_address_verified_flag(residence_address, usps_address)

			# unless residence_address.valid?
			# 	residence_address.errors.full_messages.each do |msg|
			# 		logger.debug("msg = #{msg}")
			# 	end
			# end
			previous_addresses_collection = Address.get_non_mailing_address(client.id, 6150)#client.addresses.where("address_type = 4664")
			previous_address = ""
			if previous_addresses_collection.present?
				previous_address =  previous_addresses_collection.first
				previous_address.address_type = 5608 #change address type to save prior residence address
				if residence_address.save
					previous_address.save
					ea_residence = EntityAddress.new
					ea_residence.entity_id = client.id
					ea_residence.address_id = residence_address.id
					ea_residence.entity_type = 6150
					ea_residence.save

				end
			else
				residence_address.save
				ea_residence = EntityAddress.new
				ea_residence.entity_id = client.id
				ea_residence.address_id = residence_address.id
				ea_residence.entity_type = 6150
				ea_residence.save
			end
		end
		if session[:NAVIGATE_FROM].blank?
			redirect_to show_address_path, notice: "Address information saved."
		else
			# Kiran 11/25/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
			navigate_back_to_called_page()
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","update_living_arrangement",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occured while updating address."
			redirect_to_back
	end


private

	def initialize_instance_objects_for_new_page()
		@client = Client.find(session[:CLIENT_ID])
		@address =  Address.new
		@address.address_type = 4665
		#defaulted to AR
		@address.state = 5793

		@address.non_mailing_address_type = 4664
		@address.non_mailing_addr_same_as_mailing = "N"
		@address.new_mailing_address = true
		@address.new_non_mailing_address = true
		@entity_type = 6150



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

	def default_state_to_arkansas
		if check_for_presence_of_mailing_address
			params[:address][:state] = 5793
		end
		if check_for_presence_of_non_mailing_address
			params[:address][:non_mailing_state] = 5793
		end
	end




end