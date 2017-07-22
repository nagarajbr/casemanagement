class EmployerAddressesController < AttopAncestorController

	def show
		if session[:EMPLOYER_ID].present?
			@employer = Employer.find(session[:EMPLOYER_ID])
			@addresses = Address.get_entity_addresses(@employer.id,6152)
			@notes = NotesService.get_notes(6152,session[:EMPLOYER_ID],6474,nil)
		end
		rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerAddressesController","show",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employer address."
	    redirect_to_back
	end

	def new
		@entity_type = 6152
		initialize_instance_objects_for_new_page()
		rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerAddressesController","new",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new employer address."
	    redirect_to_back
	end

	def create
		@entity_type = 6152
		if check_for_atleast_one_address_entry
			address_struct = AddressStruct.new
			address_struct.address_parameters = params[:address]
			@employer =Employer.find(session[:EMPLOYER_ID])
			address_struct.entity_obj = @employer
			address_struct.entity_type = 6152 # Employer
			address_struct.can_save = true
			address_struct = AddressService.create(address_struct)
			@addresses_error_messages = address_struct.addresses_error_messages_obj
			@address = address_struct.address_obj

			if @addresses_error_messages.present? && @addresses_error_messages.errors.full_messages.present?
				@address.new_non_mailing_address = true
				render :new
			else
				if address_struct.exception_msg.present?
					flash[:notice] = address_struct.exception_msg
				else
					provider = Provider.get_provider_information_from_tax_id_ssn(@employer.federal_ein)
					if provider.present?
						provider = provider.first
						unless Provider.address_created_for_provider(provider.tax_id_ssn)
							address_struct = AddressStruct.new
							address_struct.address_parameters = params[:address]
							address_struct.entity_obj = provider
							address_struct.entity_type = 6152
							address_struct.can_save = true
							address_struct = AddressService.create(address_struct)
						end
					end
					flash[:notice] = "Address information saved."
				end
				redirect_to show_employer_address_url
			end
		else
			flash.now[:notice] = "Please provide atleast one address."
			initialize_instance_objects_for_new_page()
			if params[:address][:notes].present?
				@address.notes = params[:address][:notes]
			end
	 		render :new
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerAddressesController","create",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new employer address."
	    redirect_to_back
	end

	def edit
		@entity_type = 6152
		@employer = Employer.find(session[:EMPLOYER_ID])
		addresses = Address.get_entity_addresses(@employer.id,6152)#@client.addresses.where("address_type = 4665").first
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
		@address.notes = NotesService.get_notes(6152,session[:EMPLOYER_ID],6474,nil)
		rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerAddressesController","edit",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit employer address."
	    redirect_to_back
	end

	def update
		@entity_type = 6152
		address_struct = AddressStruct.new
		address_struct.address_parameters = params[:address]
		@employer =Employer.find(session[:EMPLOYER_ID])
		address_struct.entity_obj = @employer
		address_struct.entity_type = 6152
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
					flash[:notice] = "Address information saved."
				end
				redirect_to show_employer_address_url
			end
		else
			redirect_to show_employer_address_url, notice: "No change in address."
		end
	 rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerAddressesController","update",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to update employer address."
	    redirect_to_back
	end


	private

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


		def initialize_instance_objects_for_new_page()
			@employer = Employer.find(session[:EMPLOYER_ID])
			@address =  Address.new
			@address.address_type = 4665
			@address.non_mailing_address_type = 4664
			@address.non_mailing_addr_same_as_mailing = "N"
			@address.new_mailing_address = true
			@address.new_non_mailing_address = true
		end

end
