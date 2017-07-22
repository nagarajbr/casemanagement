class PhonesController < AttopAncestorController
	before_action :set_phone_numbers, only: [:show,:edit,:update]
	before_action :format_phone_params, only: [:create,:update]
	def new

		@client = Client.find(session[:CLIENT_ID])
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			end
		end
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("PhonesController","new",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
	# 	redirect_to_back
	end

	def create
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			end
		end

		@client = Client.find(session[:CLIENT_ID])
		@client_notes = ClientNotes.new

		if params[:primary].present? || params[:secondary].present? ||
				params[:other].present? || params[:notes].present? || params[:email_address].present?

			result_hash = ContactService.create(params, @client, 6150)
			@phones_error_messages = result_hash[:errors_object]
			if @phones_error_messages.errors.full_messages.present?
				#@client_notes.notes = params[:notes]
				#@client.email_address = params[:email_address]
				@notes = params[:notes]
				@email = params[:email_address]
				render :new
			else
				if result_hash[:exception_msg].present?
					flash[:notice] = result_hash[:exception_msg]
				else
					flash[:notice] = "Contact information saved."
				end
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to show_phone_url
				end

			end
		else
			flash[:notice] = "Fill in at least one field."
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PhonesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving contact details."
		redirect_to_back
	end

	def show
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PhonesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def edit
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			end
		end
    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PhonesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing contact details."
		redirect_to_back
	end

	def update
		# Manoj 11/24/2015 - called from Household member step
		@menu = nil
		if params[:menu].present?
			@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			end
		end
		@client = Client.find(session[:CLIENT_ID])
		result_hash = ContactService.update(params, @client, 6150)
		@phones_error_messages = result_hash[:errors_object]

		if @phones_error_messages.errors.full_messages.present?
			@notes = params[:notes]
			@email = params[:email_address]
			render :edit
		else
			if result_hash[:exception_msg].present?
				flash[:notice] = result_hash[:exception_msg]
			else
				flash[:notice] = "Contact information saved."
			end
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_member_registration_wizard_path
				else
					redirect_to show_phone_url
				end

		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PhonesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating contact details."
		redirect_to_back
	end




  private

	def set_phone_numbers
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			@client_email = ClientEmail.where("client_id = ?",session[:CLIENT_ID]).first
			@phones = Phone.get_entity_contact_list(@client.id, 6150)#@client.phones
			#@client_notes = ClientNotes.get_client_notes_with_clientid_and_notes_type(session[:CLIENT_ID], 6039)
			#@email = @client.email_address
			# notes_obj = ClientNotes.get_client_notes_with_clientid_and_notes_type(session[:CLIENT_ID], 6039)
			# @notes = notes_obj.present? ? notes_obj.notes : ""
			@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6039,nil)
			@email = @client_email.email_address
			#logger.debug("@phones = #{@phones.inspect}")
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

			# find the last updated by record for client.
			phone_collection = EntityPhone.where("entity_type = 6150 and entity_id = ?", @client.id).order("updated_at DESC")
			@modified_by = nil
			if phone_collection.present?
				latest_phone_object = phone_collection.first
				@modified_by = latest_phone_object.updated_by
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

	# Manoj 11/24/2015
	  	def set_hoh_data()
	  		li_member_id = params[:household_member_id].to_i
			@household_member = HouseholdMember.find(li_member_id)
			@household = Household.find(@household_member.household_id)
			# @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
		end

end