class EmployerContactsController < AttopAncestorController
	before_action :set_phone_numbers, only: [:show,:edit,:update]
	before_action :format_phone_params, only: [:create,:update]
	def new
		@employer = Employer.find(session[:EMPLOYER_ID])
	rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerContactsController","new",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Attempted to create new employer contact."
	    redirect_to_back
	end

	def create
		@employer = Employer.find(session[:EMPLOYER_ID])
		if params[:primary].present? || params[:secondary].present? ||
				params[:other].present? || params[:notes].present? || params[:email_address].present?

			# @phones_error_messages = ContactService.create(params, @employer, 6152)
			result_hash = ContactService.create(params,@employer,6152)
			@phones_error_messages = result_hash[:errors_object]

			if @phones_error_messages.errors.full_messages.present?
				@notes = params[:notes]
				@email = params[:email_address]
				render :new
			else
				if result_hash[:exception_msg].present?
					flash[:notice] = result_hash[:exception_msg]
				else
					flash[:notice] = "Contact information saved."
				end
				redirect_to show_employer_contact_url
			end
		else
			flash[:notice] = "Fill in at least one field."
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmployerContactsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving employer contact details."
		redirect_to_back
	end

	def show
		rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerContactsController","show",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Error when showing employer contact details."
	    redirect_to_back
	end

	def edit
		rescue => err
	    error_object = CommonUtil.write_to_attop_error_log_table("EmployerContactsController","edit",err,current_user.uid)
	    flash[:alert] = "Error ID: #{error_object.id} - Error when editing employer contact details."
	    redirect_to_back
	end

	def update
		@employer = Employer.find(session[:EMPLOYER_ID])
		result_hash = ContactService.update(params,@employer,6152,"")
		@phones_error_messages = result_hash[:errors_object]

		# @phones_error_messages = ContactService.update(params, @employer, 6152)

		if @phones_error_messages.errors.full_messages.present?
			#@client_notes = @client_notes.present? ? @client_notes : ClientNotes.new
			#@client_notes.notes = params[:notes]
			#@employer.client_email = params[:client_email]
			@notes = params[:notes]
			@email = params[:email_address]
			render :edit
		else
			if result_hash[:exception_msg].present?
				flash[:notice] = result_hash[:exception_msg]
			else
				flash[:notice] = "Contact information saved."
			end
			redirect_to show_employer_contact_url
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmployerContactsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating employer contact details."
		redirect_to_back
	end

private
	def set_phone_numbers
		if session[:EMPLOYER_ID].present?
			@employer = Employer.find(session[:EMPLOYER_ID])
			# Rails.logger.debug("@employer = #{@employer.inspect}")
			@phones = Phone.get_entity_contact_list(@employer.id, 6152)
			# @notes = @employer.notes
			@notes = NotesService.get_notes(6152,session[:EMPLOYER_ID],6039,nil)
			# Rails.logger.debug("notes in pvt method = #{@notes}")
			@email = @employer.email_address
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
