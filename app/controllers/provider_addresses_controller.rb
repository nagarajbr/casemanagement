class ProviderAddressesController < AttopAncestorController

	def show
		if session[:PROVIDER_ID].present?
			@provider = Provider.find(session[:PROVIDER_ID])
			@addresses = Address.get_entity_addresses(@provider.id,6151)#@client.addresses.where("address_type in (4665,4664)").order(address_type: :desc)
			@notes = NotesService.get_notes(6151,session[:PROVIDER_ID],6474,nil)
		end
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderAddressesController","show",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to Access Invalid Provider Address"
	      redirect_to_back
	end

	def new
		initialize_instance_objects_for_new_page()
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderAddressesController","new",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Failed to create a new Invalid Provider Address"
	      redirect_to_back
	end

	def create
		if check_for_atleast_one_address_entry
			address_struct = AddressStruct.new
			address_struct.address_parameters = params[:address]
			@provider =Provider.find(session[:PROVIDER_ID])
			address_struct.entity_obj = @provider
			address_struct.entity_type = 6151
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
				if address_struct.exception_msg.present?
					flash[:notice] = address_struct.exception_msg
				else
					if @provider.provider_type == 6139
						employer = Employer.get_employer_information_from_federal_ein(@provider.tax_id_ssn)
						if employer.present?
							employer = employer.first
							unless Employer.address_created_for_employer(employer.federal_ein)
								addresses = Address.get_entity_addresses(employer.id,6151)
								# addresses.each do |pro_address|
								# 	entity_address = EntityAddress.new
								# 	entity_address.entity_type = 6152 #Employer
								# 	entity_address.entity_id = employer.id
								# 	entity_address.address_id = pro_address.id
								# 	entity_address.save
								# end
								address_struct = AddressStruct.new
								address_struct.address_parameters = params[:address]
								address_struct.entity_obj = employer
								address_struct.entity_type = 6152
								address_struct.can_save = true
								address_struct = AddressService.create(address_struct)
							end
						end
					end
					flash[:notice] = "Address information saved "
				end
				redirect_to show_provider_address_url
			end
		else
			flash.now[:notice] = "Please provide atleast one address!"
			initialize_instance_objects_for_new_page()
			if params[:address][:notes].present?
				@address.notes = params[:address][:notes]
			end
	 		render :new
		end

		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderAddressesController","create",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when Saving Provider Address"
			redirect_to_back

	end

	def edit
		@provider = Provider.find(session[:PROVIDER_ID])
		addresses = Address.get_entity_addresses(@provider.id,6151)#@client.addresses.where("address_type = 4665").first
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
		@address.notes = NotesService.get_notes(6151,session[:PROVIDER_ID],6474,nil)
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ProviderAddressesController","edit",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when Editing Provider Address"
			redirect_to_back
	end

	def update
		address_struct = AddressStruct.new
		address_struct.address_parameters = params[:address]
		@provider =Provider.find(session[:PROVIDER_ID])
		address_struct.entity_obj = @provider
		address_struct.entity_type = 6151
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
				if address_struct.exception_msg.present?
					flash[:notice] = address_struct.exception_msg
				else
					flash[:notice] = "Address information saved "
				end
				redirect_to show_provider_address_url
			end
		else
			redirect_to show_provider_address_url, notice: "No change in address!"
		end


		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("AddressesController","update",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error when Updating Address"
			redirect_to_back
	end




	private


	def initialize_instance_objects_for_new_page()
		@provider = Provider.find(session[:PROVIDER_ID])
		@address =  Address.new
		@address.address_type = 4665
		@address.non_mailing_address_type = 4664
		@address.non_mailing_addr_same_as_mailing = "N"
		@address.new_mailing_address = true
		@address.new_non_mailing_address = true
	end


	def check_for_atleast_one_address_entry
		return check_for_presence_of_mailing_address || check_for_presence_of_non_mailing_address
	end

	def check_for_presence_of_mailing_address
		if ( params[:address][:in_care_of].present? ||
				params[:address][:address_line1].present? ||
				#params[:address][:address_line2].present? ||
				params[:address][:city].present? ||
				params[:address][:state].present? ||
				params[:address][:zip].present? #||
				#params[:address][:zip_suffix].present? ||
				#params[:address][:county].present?
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
				params[:address][:non_mailing_state].present? ||
				params[:address][:non_mailing_zip].present? #||
				#params[:address][:non_mailing_zip_suffix].present? ||
				#params[:address][:non_mailing_county].present?
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
	end

end
