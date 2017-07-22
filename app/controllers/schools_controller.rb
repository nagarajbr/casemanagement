class SchoolsController < AttopAncestorController

  before_action :set_id, only: [:show,:edit,:update,:destroy]

	# def school_new_search
	# rescue => err
	#     error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","school_new_search",err,current_user.uid)
	#     flash[:alert] = "Error ID: #{error_object.id} - Failed to search school."
	#     redirect_to_back
	# end

	def search

		l_school_serach_service = SearchModule::SchoolSearch.new
		return_obj = l_school_serach_service.search(params)
		@show_new_button = true


		if return_obj.class.name == "String"
			# Rails.logger.debug(" return_obj.class.name = #{return_obj.class.name}")
			# fail
			if return_obj == "No results found"
				render :search_result
  			end
  			#redirect_to new_provider_search_path
  			flash.now[:notice] = return_obj
  			school_session_params(params)
		else
		 	reset_school_session_params()
		 	l_records_per_page = SystemParam.get_pagination_records_per_page
		 	@school = return_obj.page(params[:page]).per(l_records_per_page)
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","search",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to search school."
	     redirect_to_back
	end

	   def index
		if session[:SCHOOLS_ID].present?
			# Rails.logger.debug("session[:SCHOOLS_ID] = #{session[:SCHOOLS_ID]}")
				@school = School.find(session[:SCHOOLS_ID])
				# @addresses = Address.get_entity_addresses(@school.id,6151)
		end

		rescue => err
	     error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","index",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to access school information."
	    redirect_to_back
		end




	def set_selected_schools_in_session
		session[:SCHOOLS_ID] = params[:id]
	  	redirect_to show_school_path(params[:id])
	  	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","set_selected_schools_in_session",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} -  Failed to access school information."
	    redirect_to_back

	end



	def new
		if session[:SCHOOLS_ID].present?
			session[:SCHOOLS_ID] = nil
		end
		if params[:from_client_management] == 'CLIENT_MANAGEMENT'
			@client_managment = 'CLIENT_MANAGEMENT'
		end
		@school = School.new
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","new",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} -  Failed to save new school information."
	    redirect_to_back
	end

	def create
       @school = School.new(school_params)
       if @school.valid?
			return_object = SchoolService.create_school(@school,params[:notes])
			if return_object.class.name == "String"
				flash[:notice] = return_object
				render :new
			else
				session[:SCHOOLS_ID] = @school.id
				flash[:notice] = "School information created."
				if params[:from_client_management] == 'CLIENT_MANAGEMENT'
					redirect_to new_education_path('CLIENT')
				else
					redirect_to show_school_path(@school)
				end
			end
		else
			render :new
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","create",err,current_user.uid)
	   flash[:alert] = "Error ID: #{error_object.id} - Failed to create school information."
	    redirect_to_back
	end

	def show
		@school = School.find(params[:id])
		@notes = NotesService.get_notes(6338,@school.id,6523,@school.id)
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","show",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid schools."
	    redirect_to_back
    end

	def edit
		@notes = nil # NotesService.get_notes(6338,@school.id,6523,@school.id)
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","edit",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to update school information."
	    redirect_to_back
    end

	def update
		@school.school_type = school_params[:school_type]
		@school.school_name = school_params[:school_name]
		@school.web_address = school_params[:web_address]
		if @school.valid?
			return_object = SchoolService.update_school(@school,params[:notes])
			if return_object.class.name == "String"
				flash[:notice] = return_object
				render :edit
			else
				session[:SCHOOLS_ID] = @school.id
				flash[:notice] = "School information saved."
				redirect_to show_school_path(@school)
			end
		else
			render :edit
		end
	 rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","update",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to update school information."
	    redirect_to_back
	end

	def destroy
		@notes = NotesService.get_notes(6338,@school.id,6523,@school.id)
		@addresses = Address.get_entity_addresses(@school.id,6153)
		ls_msg = SchoolService.delete_school(@school,@addresses,@notes)
		if ls_msg == "SUCCESS"
			session[:SCHOOLS_ID] = nil
			flash[:notice] = "School information successfully deleted."
			redirect_to schools_search_path
		else
			flash[:notice] = ls_msg
			render :show
		end
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolsController","destroy",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to delete school information."
	    redirect_to_back
	end

	private


	def school_params
    	params.require(:school).permit(:school_type,:school_name,:web_address)
    end


    def set_id
		@school = School.find(params[:id])
	end


	def school_session_params(arg_param)
		if arg_param[:school_name].present?
	    	session[:NEW_SCHOOL_NAME] =  arg_param[:school_name]
	    end

	end

	def reset_school_session_params()
		if session[:NEW_SCHOOL_NAME].present?
  			session[:NEW_SCHOOL_NAME] = nil
  		end

	end

end


