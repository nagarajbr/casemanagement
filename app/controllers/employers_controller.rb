class EmployersController < AttopAncestorController

	before_action :set_id, only: [:show,:edit,:update,:destroy]
	before_action :format_ein

	def employer_new_search
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","employer_new_search",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to search employer."
	   redirect_to_back
	end

	def search

		l_employer_serach_service = SearchModule::EmployerSearch.new
		return_obj = l_employer_serach_service.search(params)
		@show_new_button = true
		if return_obj.class.name == "String"
			if return_obj == "No results found"
				render :search_result
  			end
  			#redirect_to new_provider_search_path
  			flash.now[:notice] = return_obj
  			employer_session_params(params)
		else
		 	reset_employer_session_params()
		 	l_records_per_page = SystemParam.get_pagination_records_per_page
		 	@employers = return_obj.page(params[:page]).per(l_records_per_page)
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","search",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to search employer."
	    redirect_to_back
	end


	def set_selected_employer_in_session
		session[:EMPLOYER_ID] = params[:id]
	  	redirect_to employer_path(params[:id])
	  	rescue => err
    	error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","set_selected_employer_in_session",err,current_user.uid)
      	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employer."
      	redirect_to_back
	end

	def index
		if session[:EMPLOYER_ID].present?
		   @employers = Employer.find(session[:EMPLOYER_ID])
		end
	 rescue => err
    	error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","index",err,current_user.uid)
      	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employer."
      	redirect_to_back
	end

	def new
		if session[:EMPLOYER_ID].present?
			session[:EMPLOYER_ID] = nil
		end
		@employer = Employer.new
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","new",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to create new employer."
	    redirect_to_back
	end

	def create
		@employer = Employer.new(employer_params)
		if @employer.valid?
			return_object = EmployerService.create_employer(@employer,employer_params,params,params[:notes])
			if return_object.class.name == "String"
				flash[:notice] = return_object
				render :new
			else
				session[:EMPLOYER_ID] = @employer.id
				flash[:notice] = "Employer information created."
				if session[:NAVIGATE_FROM].present?
					navigate_back_to_called_page()
				else
					redirect_to employer_path(@employer)
				end

			end
		else
			render :new
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","create",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to create new employer."
	    redirect_to_back
	end

	def show
		@employer = Employer.find(params[:id])
		@notes = NotesService.get_notes(6152,@employer.id,6522,@employer.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","show",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to create new employer."
	    redirect_to_back
	end

	def edit
		@notes = nil # NotesService.get_notes(6152,@employer.id,6522,@employer.id)
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","edit",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to edit employer."
	    redirect_to_back
	end

	def update
		@employer.flag = employer_params[:flag]
		@employer.federal_ein = employer_params[:federal_ein]
		@employer.state_ein = employer_params[:state_ein]
		@employer.employer_name = employer_params[:employer_name]
		@employer.employer_country_code = employer_params[:employer_country_code]
		@employer.employer_contact = employer_params[:employer_contact]
		@employer.employer_optional_contact = employer_params[:employer_optional_contact]
		if @employer.valid?
			return_object = EmployerService.update_employer(@employer,params[:notes])
			if return_object.class.name == "String"
				flash[:notice] = return_object
				render :edit
			else
				session[:EMPLOYER_ID] = @employer.id
				flash[:notice] = "Employer information updated."
				redirect_to @employer
			end
		else
			render :edit
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployersController","update",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to update employer."
	    redirect_to_back
	end



	private


	def employer_params
    	params.require(:employer).permit(:flag,:federal_ein, :state_ein, :employer_name, :employer_country_code,
       :employer_contact, :employer_optional_contact)
    end


    def set_id
    	#Rails.logger.debug("params[:id]= #{session[:EMPLOYER_ID].inspect}")
		@employer = Employer.find(params[:id])
	end

	def format_ein
		if params[:employer].present? && params[:employer][:federal_ein].present?
	  		params[:employer][:federal_ein] = params[:employer][:federal_ein].scan(/\d/).join
	  	end
	  	if params[:employer].present? && params[:employer][:state_ein].present?
	  		params[:employer][:state_ein] = params[:employer][:state_ein].scan(/\d/).join
	  	end

	  	if params.present? && params[:federal_ein].present?
	  		params[:federal_ein] = params[:federal_ein].scan(/\d/).join
	  	end

	  	if params.present? && params[:state_ein].present?
	  		params[:state_ein] = params[:state_ein].scan(/\d/).join
	  	end

	end

	def employer_session_params(arg_param)
		if arg_param[:employer_name].present?
	    	session[:NEW_EMPLOYER_NAME] =  arg_param[:employer_name]
	    end

	     if arg_param[:federal_ein].present?
	    	session[:FEDERAL_EIN] =  arg_param[:federal_ein]
	    end
	end

	def reset_employer_session_params()
		if session[:NEW_EMPLOYER_NAME].present?
  			session[:NEW_EMPLOYER_NAME] = nil
  		end

  		if session[:FEDERAL_EIN].present?
  			session[:FEDERAL_EIN] = nil
  		end
	end

end
