class SchoolsContactsController < AttopAncestorController
	before_action :set_phone_numbers, only: [:show,:edit,:update]
	before_action :format_phone_params, only: [:create,:update]
	def new
		@entity_type = 6338
		@school = School.find(session[:SCHOOLS_ID])
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolContactsController","new",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to save new school contact."
	    redirect_to_back
	end

	def create
		@school = School.find(session[:SCHOOLS_ID])
		if params[:primary].present? || params[:secondary].present? ||
				params[:other].present? || params[:contact_notes].present? || params[:email_address].present?

			# @phones_error_messages = ContactService.create(params, @school, 6338)
			result_hash = ContactService.create(params, @school, 6338)
			@phones_error_messages = result_hash[:errors_object]

			if @phones_error_messages.errors.full_messages.present?
				@notes = params[:contact_notes]
				@email = params[:email_address]
				render :new
			else
				if result_hash[:exception_msg].present?
					flash[:notice] = result_hash[:exception_msg]
				else
					flash[:notice] = "Contact information saved."
				end
				redirect_to show_schools_contact_url
			end
		else
			flash[:notice] = "Fill in at least one field."
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SchoolContactsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to save new school contact."
		redirect_to_back
	end

	def show
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolContactsController","show",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to show invalid school contact."
	    redirect_to_back
	end

	def edit
		@entity_type = 6338
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("SchoolContactsController","edit",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Failed to update school contact."
	    redirect_to_back
	end

	def update
		@school = School.find(session[:SCHOOLS_ID])
		result_hash = ContactService.update(params, @school, 6338,"")
		@phones_error_messages = result_hash[:errors_object]
		# @phones_error_messages = ContactService.update(params, @school, 6338)

		if @phones_error_messages.errors.full_messages.present?
			@notes = params[:contact_notes]
			@email = params[:email_address]
			@entity_type = 6338
			render :edit
		else
			if result_hash[:exception_msg].present?
				flash[:notice] = result_hash[:exception_msg]
			else
				flash[:notice] = "Contact information saved."
			end
			redirect_to show_schools_contact_url
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("SchoolContactsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to update school contact."
		redirect_to_back
	end
private

	def set_phone_numbers
		if session[:SCHOOLS_ID].present?
			@school = School.find(session[:SCHOOLS_ID])
			@phones = Phone.get_entity_contact_list(@school.id, 6338)
			# @notes = @school.contact_notes
			@notes = NotesService.get_notes(6338,session[:SCHOOLS_ID],6039,nil)
			@email = @school.email_address
			@primary_phone = @phones.where("phone_type = 4661")
			if @primary_phone.present?
				@primary_phone = @primary_phone.first
			end
			@secondary_phone = @phones.where("phone_type = 4662")
			if @secondary_phone.present?
				@secondary_phone = @secondary_phone.first
			end
			@other_phone = @phones.where("phone_type = 4663")
			if @other_phone.present?
				@other_phone = @other_phone.first
			end
		end
	end

	def format_phone_params
		if params[:primary].present?
	  		params[:primary] = params[:primary].scan(/\d/).join
	  	end
	  	if params[:secondary].present?
	  		params[:secondary] = params[:secondary].scan(/\d/).join
	  	end
	  	if params[:other].present?
	  		params[:other] = params[:other].scan(/\d/).join
	  	end
	end
end


