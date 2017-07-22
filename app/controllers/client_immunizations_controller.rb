class ClientImmunizationsController < AttopAncestorController
	before_action :get_client

	def show

		@client_immunization = ClientImmunization.get_client_immunization(session[:CLIENT_ID])
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6050,session[:CLIENT_ID])

		if @menu == 'ASSESSMENT'
			@client_assessment.current_step = "/ASSESSMENT/client_immunization/show"
			session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step
		end
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunizationsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def new
		@client_immunization = ClientImmunization.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunizationsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating immunization details."
		redirect_to_back

	end

	def create
		if params[:exempt_from_immunization].present? || params[:immunizations_record].present?
			msg = ''
			@client = Client.find(session[:CLIENT_ID])

			ls_msg = ClientImmunizationService.creat_client_immunization_and_notes(params[:exempt_from_immunization],params[:notes],params[:immunizations_record],@client)
			if ls_msg == "SUCCESS"

				flash[:notice] = "Immunization information saved."
			else

				flash[:notice] = ls_msg
				render :new
			end

			# Manoj start
			if session[:NAVIGATE_FROM].blank?

					if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'

						redirect_to start_household_characteristics_data_entry_wizard_path
					else

						redirect_to show_client_immunization_path(@menu)
					end

			else

				# Manoj 09/18/2014 - after correcting data elemnents go back to Application screening if you have come from application screening page.
				navigate_back_to_called_page()
			end

			# Manoj end

		else
			@client_immunization = ClientImmunization.new
			@client_immunization.errors[:base] = "Immunization information not provided."
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunizationsController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving immunization details."
		redirect_to_back
	end

	def edit
		@client_immunization = ClientImmunization.get_client_immunization(session[:CLIENT_ID])
		if @client_immunization.blank?
			@client_immunization = ClientImmunization.new
		end
		@notes =nil # NotesService.get_notes(6150,session[:CLIENT_ID],6050,session[:CLIENT_ID])
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunizationsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing immunization details."
		redirect_to_back
	end

	def update
		msg = ''
		@client = Client.find(session[:CLIENT_ID])
		@client_immunization = ClientImmunization.get_client_immunization(session[:CLIENT_ID])
		if @client_immunization.present?
			if ( @client_immunization.immunizations_record != params[:immunizations_record] )
				@client_immunization.immunizations_record = params[:immunizations_record]
			end
		else
			@client_immunization = ClientImmunization.new
			@client_immunization.client_id = session[:CLIENT_ID]
			@client_immunization.immunizations_record = params[:immunizations_record]
		end

		if (@client.exempt_from_immunization.present? && params[:exempt_from_immunization].present? && params[:exempt_from_immunization] != @client.exempt_from_immunization) ||
			(@client.exempt_from_immunization.present? && !params[:exempt_from_immunization].present?) || (!(@client.exempt_from_immunization.present?) && params[:exempt_from_immunization].present?)
			@client.exempt_from_immunization = params[:exempt_from_immunization]
		end
		ls_msg = ClientImmunizationService.update_client_immunization_and_notes(@client_immunization,@client,params[:notes])
		if ls_msg == "SUCCESS"
			flash[:notice] = "Immunization information saved."
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				redirect_to start_household_characteristics_data_entry_wizard_path
			else
				redirect_to show_client_immunization_path(@menu)
			end
		else
			flash[:notice] = ls_msg
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunizationsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating immunization details."
		redirect_to_back
	end

	def destroy
		@client_immunization = ClientImmunization.get_client_immunization(session[:CLIENT_ID])
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6050,session[:CLIENT_ID])
		ls_msg = ClientImmunizationService.delete_client_immunization_and_notes(@client_immunization,@notes,@client)
		if ls_msg == "SUCCESS"
			flash[:notice] = "Immunization information deleted."
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				redirect_to start_household_characteristics_data_entry_wizard_path
			else
				redirect_to show_client_immunization_path(@menu)
			end
		else
			flash[:notice] = ls_msg
			render :show
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientImmunizationsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when deleting immunization details."
		redirect_to_back
	end


	private
		# Manoj 11/24/2015
	  	def set_hoh_data()
	  		li_member_id = params[:household_member_id].to_i
			@household_member = HouseholdMember.find(li_member_id)
			@household = Household.find(@household_member.household_id)
			# @head_of_household_name = HouseholdMember.get_hoh_name(@household.id)
		end

		def get_client()
			@client = Client.find(session[:CLIENT_ID])
	    	@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				set_hoh_data()
			elsif  @menu == 'ASSESSMENT'
				if session[:CLIENT_ASSESSMENT_ID].present? && session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@assessment_id = session[:CLIENT_ASSESSMENT_ID].to_i
					@client_assessment = ClientAssessment.find(@assessment_id)
					@assessment_object = @client_assessment
				end
			else
				# CLIENT
				# no special procesing
			end
		end





end
