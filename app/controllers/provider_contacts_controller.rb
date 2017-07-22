class ProviderContactsController < AttopAncestorController
	before_action :set_phone_numbers, only: [:show,:edit,:update]
	before_action :format_phone_params, only: [:create,:update]
	def new
		@provider = Provider.find(session[:PROVIDER_ID])
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderContactsController","new",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid provider cantacts"
	      redirect_to_back
	end

	def create
		@provider = Provider.find(session[:PROVIDER_ID])
		if params[:primary].present? || params[:secondary].present? ||
				params[:other].present? || params[:notes].present? || params[:client_email].present?

			# @phones_error_messages = ContactService.create(params, @provider, 6151)
			result_hash = ContactService.create(params, @provider, 6151)
			@phones_error_messages = result_hash[:errors_object]
			if @phones_error_messages.errors.full_messages.present?
				@notes = params[:notes]
				@email = params[:client_email]
				render :new
			else
				if result_hash[:exception_msg].present?
					flash[:notice] = result_hash[:exception_msg]
				else
					flash[:notice] = "Contact information saved."
				end
				redirect_to show_provider_contact_url
			end
		else
			@phones_error_messages = SystemParam.new
			@phones_error_messages.description = 'something'
			@phones_error_messages.errors[:base] << "Fill in at least one contact information"
			#flash[:notice] = "Fill in at least one contact information."
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderContactsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when Saving Provider Contact Details"
		redirect_to_back
	end

	def show
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderContactsController","show",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid provider cantacts"
	      redirect_to_back
	end

	def edit
		rescue => err
	      error_object = CommonUtil.write_to_attop_error_log_table("ProviderContactsController","edit",err,current_user.uid)
	      flash[:alert] = "Error ID: #{error_object.id} - Attempted to edit invalid provider cantacts"
	      redirect_to_back
	end

	def update
		@provider = Provider.find(session[:PROVIDER_ID])
		result_hash = ContactService.update(params, @provider, 6151)
		@phones_error_messages = result_hash[:errors_object]

		if @phones_error_messages.errors.full_messages.present?
			#@client_notes = @client_notes.present? ? @client_notes : ClientNotes.new
			#@client_notes.notes = params[:notes]
			#@provider.client_email = params[:client_email]
			@notes = params[:notes]
			@email = params[:client_email]
			render :edit
		else
			if result_hash[:exception_msg].present?
				flash[:notice] = result_hash[:exception_msg]
			else
				flash[:notice] = "Contact information saved."
			end
			redirect_to show_provider_contact_url
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ProviderContactsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when Updating Provider Contact Details"
		redirect_to_back
	end

private

	def set_phone_numbers
		if session[:PROVIDER_ID].present?
			@provider = Provider.find(session[:PROVIDER_ID])
			@phones = Phone.get_entity_contact_list(@provider.id, 6151)#@provider.phones
			# @notes = @provider.notes
			@notes = NotesService.get_notes(6151,session[:PROVIDER_ID],6039,nil)
			@email = @provider.email_address
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
