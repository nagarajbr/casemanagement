class ProvidersController < AttopAncestorController

	def index
		# Manoj Patil 01/02/2014
		# Rules
		# 1. Show provider with Show Link
		# 2. Show Branch Offices link if the provider is Master/Head office provider.
		# 3.Show Add Branch Offices Button if the provider is Master/Head office provider.
		if session[:PROVIDER_ID].present?
			@provider = Provider.find(session[:PROVIDER_ID])
			@addresses = Address.get_entity_addresses(@provider.id,6151)
			if @provider.id == @provider.head_office_provider_id
				@head_provider_id = session[:PROVIDER_ID].to_i
				@head_office_indicator = "Yes"
			else
				@head_office_indicator = "No"
				# Not a head office - it is branch office - hence populate @head_provider
				@head_provider_id = @provider.head_office_provider_id
				@head_provider = Provider.find(@head_provider_id)
			end
		end
	rescue => err
    	error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","index",err,current_user.uid)
      	flash[:alert] = "Error ID: #{error_object.id} - Attempted to Access Invalid Provider"
      	redirect_to_back
	end

	def new
		@provider = Provider.new
		if session[:NEW_PROVIDER_NAME].present?
			@provider.provider_name = session[:NEW_PROVIDER_NAME]

		end

		if session[:NEW_TAX_ID_SSN].present?
			@provider.tax_id_ssn = session[:NEW_TAX_ID_SSN]
		end
	rescue => err
    	error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","new",err,current_user.uid)
      	flash[:alert] = "Error ID: #{error_object.id} - Failed to create a new Provider"
      	redirect_to_back

	end

	def create
		@provider = Provider.new(provider_params)
		# Pending Status
		@provider.status = 6155

		if @provider.valid?
			return_object = ProvidersService.create_provider_and_notes(@provider,params[:notes])
			if return_object.class.name == "String"
				flash[:notice] = return_object
				render :new
			else
				session[:PROVIDER_ID] = return_object.id
				flash[:notice] = "Provider information saved"
				redirect_to show_provider_path(return_object.id)
			end
		else
			render :new
		end
	rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","create",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Failed to create provider"
      redirect_to_back
	end


	def show
		# Rule : If Branch office then show only few fields
		# 2. If Head office show all fields.
	 	@provider = Provider.find(params[:provider_id].to_i)
	 	@notes = NotesService.get_notes(6151,@provider.id,6505,@provider.id)
	 	@addresses = Address.get_entity_addresses(@provider.id,6151)
	 	session[:PROVIDER_ID] = @provider.id
	 	if @provider.id != @provider.head_office_provider_id
	 		@branch_office = "Yes"
			@head_provider_id = @provider.head_office_provider_id
			@head_provider = Provider.find(@head_provider_id)
		else
			@branch_office = "No"
		end
	rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","show",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Provider"
      redirect_to_back
	end

	def edit
		@provider = Provider.find(params[:provider_id].to_i)
		@notes = NotesService.get_notes(6151,@provider.id,6505,@provider.id)
		@addresses = Address.get_entity_addresses(@provider.id,6151)
		user = User.find(current_user.uid)
		@user_role = user.get_role_id()
		session[:PROVIDER_ID] = @provider.id
		provider_status = @provider.status
		set_status_drop_down(provider_status)

	rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","edit",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Provider"
     redirect_to_back
	end

	def update
		@provider = Provider.find(params[:provider_id].to_i)
		@addresses = Address.get_entity_addresses(@provider.id,6151)
		session[:PROVIDER_ID] = @provider.id
		provider_status = @provider.status
		set_status_drop_down(provider_status)
		l_params = provider_params

		# if provider is Inactivating - just update
		if l_params[:status] == "6157"
			@provider.provider_name = l_params[:provider_name]
			@provider.provider_type = l_params[:provider_type]
			@provider.contact_person = l_params[:contact_person]
			@provider.provider_country_code = l_params[:provider_country_code]
			@provider.classification = l_params[:classification]
			@provider.license_number = l_params[:license_number]
			@provider.license_expire_dt = l_params[:license_expire_dt]
			@provider.tax_id_ssn = l_params[:tax_id_ssn]
			@provider.web_address = l_params[:web_address]
			@provider.status = l_params[:status]

			if @provider.valid?
			 	return_object = ProvidersService.update_provider_and_notes(@provider,params[:notes])
				 if return_object.class.name == "String"
				 	render :edit
				 else
				 	Provider.sync_header_provider_status_to_branches(@provider.id,@provider.status)
			 		redirect_to show_provider_path(@provider.id), notice: "Provider information saved"
				 end
			else
			 	render :edit
			end
		else
			# any changes to SSN and Name should be sent to AASIS.
			if (@provider.tax_id_ssn != l_params[:tax_id_ssn] || @provider.provider_name != l_params[:provider_name])
				@provider.status = 6155
				@provider.provider_name = l_params[:provider_name]
				@provider.provider_type = l_params[:provider_type]
				@provider.contact_person = l_params[:contact_person]
				@provider.provider_country_code = l_params[:provider_country_code]
				@provider.classification = l_params[:classification]
				@provider.license_number = l_params[:license_number]
				@provider.license_expire_dt = l_params[:license_expire_dt]
				@provider.tax_id_ssn = l_params[:tax_id_ssn]
				@provider.web_address = l_params[:web_address]
				return_object = ProvidersService.update_provider_and_notes(@provider,params[:notes])
				 if return_object.class.name == "String"
				 	render :edit
				 else
				 	Provider.sync_header_provider_status_to_branches(@provider.id,@provider.status)
			 		redirect_to show_provider_path(@provider.id), notice: "Provider information saved"
				 end
			else
				# No changes to ssn & name - some other changes - just save
				@provider.provider_name = l_params[:provider_name]
				@provider.provider_type = l_params[:provider_type]
				@provider.contact_person = l_params[:contact_person]
				@provider.provider_country_code = l_params[:provider_country_code]
				@provider.classification = l_params[:classification]
				@provider.license_number = l_params[:license_number]
				@provider.license_expire_dt = l_params[:license_expire_dt]
				@provider.tax_id_ssn = l_params[:tax_id_ssn]
				@provider.web_address = l_params[:web_address]
				@provider.status = l_params[:status] if l_params[:status].present?
				return_object = ProvidersService.update_provider_and_notes(@provider,params[:notes])
				 if return_object.class.name == "String"
				 	render :edit
				 else
				 	Provider.sync_header_provider_status_to_branches(@provider.id,@provider.status)
			 		redirect_to show_provider_path(@provider.id), notice: "Provider information saved"
				 end
			end
		end

	rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","update",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Failed to update provider"
	      redirect_to_back
	 end


	#  Branch office start
	def new_branch_office
		@head_provider_id =params[:head_provider_id].to_i
		@head_provider = Provider.find(@head_provider_id)
		@provider = Provider.new
	rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","new_branch_office",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to Access Invalid Provider"
	      redirect_to_back
	end

	def create_branch_office
		@provider = Provider.new
		@head_provider_id = params[:head_provider_id].to_i
		@head_provider = Provider.find(@head_provider_id)
		# @head_office_indicator = "Yes"
		# @provider = Provider.new(branch_office_provider_params)
		# @provider.status = 6155
		@provider.head_office_provider_id = @head_provider.id
		@provider.provider_type = @head_provider.provider_type
		@provider.provider_country_code = @head_provider.provider_country_code
		@provider.classification = @head_provider.classification
		@provider.web_address = @head_provider.web_address
		# Read from Params
		l_params = branch_office_provider_params
		@provider.provider_name = l_params[:provider_name]
		@provider.contact_person = l_params[:contact_person]
		@provider.license_number = l_params[:license_number]
		@provider.license_expire_dt= l_params[:license_expire_dt]
		@provider.web_address = l_params[:web_address]

		if @provider.valid?
			return_object = ProvidersService.create_provider_branch_and_notes(@provider,params[:notes])
			if return_object.class.name == "String"
				flash[:notice] = return_object
				render :new
			else
				session[:PROVIDER_ID] = return_object.id
				flash[:notice] = "Provider Branch Office saved"
				redirect_to show_provider_path(return_object.id)
			end
		else
			render :new
		end
	rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","create_branch_office",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Failed to create Branch Office for provider"
      redirect_to_back
	end

	def edit_branch_office
		@provider = Provider.find(params[:branch_office_id].to_i)
		@addresses = Address.get_entity_addresses(@provider.id,6151)
		@notes = NotesService.get_notes(6151,@provider.id,6505,@provider.id)
		branch_office_provider()
		provider_status = @provider.status
		set_status_drop_down(provider_status)
	rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","edit_branch_office",err,current_user.uid)
      flash[:alert] = "Error ID: #{error_object.id} - Attempted to Access Invalid Provider"
      redirect_to_back
	end

	def update_branch_office
		@provider = Provider.find(params[:branch_office_id].to_i)
		@addresses = Address.get_entity_addresses(@provider.id,6151)
		session[:PROVIDER_ID] = @provider.id
		l_params = branch_office_provider_params
		provider_status = @provider.status
		set_status_drop_down(provider_status)

		@provider.provider_name = l_params[:provider_name]
		@provider.contact_person = l_params[:contact_person]
		@provider.license_number = l_params[:license_number]
		@provider.license_expire_dt = l_params[:license_expire_dt]
		@provider.web_address = l_params[:web_address]
		@provider.status = l_params[:status]
		return_object = ProvidersService.update_provider_branch_and_notes(@provider,params[:notes])
		 if return_object.class.name == "String"
		 	branch_office_provider()
		 	render :edit_branch_office
		 else
	 		redirect_to show_provider_path(@provider.id), notice: "Branch Office information Updated"
		 end
	rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","update_branch_office",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Failed to update Branch Office information"
	      redirect_to_back
	end



	def branch_offices_index
		@head_provider_id = params[:head_provider_id].to_i
		@head_provider = Provider.find(@head_provider_id)
		@branch_offices_of_master_provider =Provider.get_brabch_offices(@head_provider_id)
	rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","update_branch_office",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Provider"
	      redirect_to_back

	end

	#  Branch office End


	#Start search

	def provider_new_search
		@form_path = provider_search_path
		@search_screen =  "provider_new_search"
      	session[:NAVIGATE_FROM] =nil
	end

	def payments_provider_new_search
		@form_path = search_payments_provider_path
		@search_screen =  "payments_provider_new_search"
		# @form_path = payments_provider_search_path
		session[:NAVIGATE_FROM] = provider_service_authorizations_index_path
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","payments_provider_new_search",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access provider new search "
	      redirect_to_back


	end

	def search
	  	common_search()

		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","search",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access provider search results"
	      redirect_to_back

	end

	def search_payments_provider
		common_search()
	rescue => err
	  	error_object = CommonUtil.write_to_attop_error_log_table("ProvidersController","search_payments_provider",err,current_user.uid)
	  	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access provider search results"
  		redirect_to_back
	end





	def set_selected_provider_in_session
	  	session[:PROVIDER_ID] = params[:id]
	  	if session[:NAVIGATE_FROM].present?
	  		navigate_back_to_called_page()
	  	else
	  		redirect_to provider_index_path
	  	end
	end

#End search

private

	def provider_params
    	params.require(:provider).permit(:provider_name,:provider_type, :contact_person, :provider_country_code,:classification,
       :license_number, :license_expire_dt, :tax_id_ssn,:web_address,:notes,:status)
    end

    def branch_office_provider_params
    	params.require(:provider).permit(:provider_name,:contact_person,
       :license_number, :license_expire_dt,:web_address,:notes,:status)
    end


	def provider_session_params(arg_param)
		if arg_param[:provider_name].present?
	    	session[:NEW_PROVIDER_NAME] =  arg_param[:provider_name]
	    end

	     if arg_param[:tax_id_ssn].present?
	    	session[:NEW_TAX_ID_SSN] =  arg_param[:tax_id_ssn]
	    end
	end

	def reset_provider_session_params()
		if session[:NEW_PROVIDER_NAME].present?
  			session[:NEW_PROVIDER_NAME] = nil
  		end

  		if session[:NEW_TAX_ID_SSN].present?
  			session[:NEW_TAX_ID_SSN] = nil
  		end
	end

	def branch_office_provider()
		@head_provider_id = @provider.head_office_provider_id
		@head_provider = Provider.find(@head_provider_id)
		provider_status = @provider.status
		if provider_status == 6156 #  AASIS Verified
			l_array = Array.new
			l_array << 6157 # Inactive
			@edit_provider_status = CodetableItem.items_to_include(157,l_array,"Edit dropdown values for Approved Provider")
		elsif provider_status == 6157 #  Inactive
			l_array = Array.new
			l_array << 6157 # Inactive
			l_array << 6156 #  AASIS Verified.
			@edit_provider_status = CodetableItem.items_to_include(157,l_array,"Edt dropdown values for Inactive Provider")
		end
	end

	def set_status_drop_down(arg_status_type)

		if arg_status_type == 6156 && @user_role == 5 #  AASIS Verified & supervisor role
			l_array = Array.new
			l_array << 6156 #  AASIS Verified
			l_array << 6157 # Inactive
			@edit_provider_status = CodetableItem.items_to_include(157,l_array,"Edit dropdown values for Approved Provider")
		elsif arg_status_type == 6157 && @user_role == 5 #  Inactive & supervisor role
			l_array = Array.new
			l_array << 6157 # Inactive
			l_array << 6155 #  Pending
			@edit_provider_status = CodetableItem.items_to_include(157,l_array,"Edit dropdown values for Inactive Provider")
		elsif (arg_status_type == 6155 || arg_status_type == 6540) && @user_role == 6 #  Pending & Manager Role
			l_array = Array.new
			l_array << 6155 #  Pending
			l_array << 6540 #  Ready for AASIS
			@edit_provider_status = CodetableItem.items_to_include(157,l_array,"Edit dropdown values for Approved Provider")
		end
	end

	def common_search()
		if session[:NAVIGATE_FROM].present?
	  		@show_register_new_provider_button = false
	  	end
		l_provider_serach_service = SearchModule::ProviderSearch.new
		return_obj = l_provider_serach_service.search(params)
		@show_new_button = true
		if return_obj.class.name == "String"
			if return_obj == "No results found"
				if params[:called_from] == "payments_provider_new_search"

				else
					render :search_result
				end
  			end
  			#redirect_to new_provider_search_path
  			flash.now[:notice] = return_obj
  			provider_session_params(params)
		else
			reset_provider_session_params()
			@providers = return_obj
		end
	end
end



