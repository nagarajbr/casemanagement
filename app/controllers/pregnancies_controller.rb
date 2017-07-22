class PregnanciesController < AttopAncestorController
	# Author : Manojkumar PAtil
	# Date : 08/04/2014
	# Description : CRUD for Pregnancy Model

	before_action :get_client

	def new
		# @menu = nil
	 #    if params[:menu].present?
		# 	@menu = params[:menu]
		# 	if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		# 		set_hoh_data()
		# 	end
		# end
		# if session[:CLIENT_ID].present?
		# 	@client = Client.find(session[:CLIENT_ID])
		# 	@pregnancy = @client.pregnancies.new
		# end
		@pregnancy = @client.pregnancies.new
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when creating new pregnancy details."
		redirect_to_back
	end

	def create
		# Manoj 12/07/2015
		# fail
		# @menu = nil
	 #    if params[:menu].present?
		# 	@menu = params[:menu]
		# 	if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		# 		set_hoh_data()
		# 	end
		# end

		# @client = Client.find(session[:CLIENT_ID])
		l_param = pregnancy_params
		@pregnancy = @client.pregnancies.new(l_param)

		if @pregnancy.valid?
			ls_msg = PregnancyService.create_pregnancy(@pregnancy,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Pregnancy saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'

					redirect_to start_household_characteristics_data_entry_wizard_path
				else

					redirect_to show_pregnancy_path(@menu)
				end

			else
				flash[:notice] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","create",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when saving pregnancy details."
		redirect_to_back
	end

	def show
		if assessment_plan_not_required
			# Though the table allows One to many relation - Current Business functionality allows one-to-one relation- hence used last record for client.
			@pregnancy = @client.pregnancies.last
			# self.get_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
			@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6481,session[:CLIENT_ID])
			if @menu == 'ASSESSMENT'
				@client_assessment.current_step = "/ASSESSMENT/clients/medical_pregnancy/show"
				session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step
			end
			l_records_per_page = SystemParam.get_pagination_records_per_page
			@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
		else
			session[:NAVIGATE_FROM] = show_pregnancy_path
			redirect_to assessment_activity_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when showing pregnancy details."
		redirect_to_back
	end

	def edit
		# if session[:CLIENT_ID].present?
			# @client = Client.find(session[:CLIENT_ID])
			# @menu = nil
			# if params[:menu].present?
			# 	@menu = params[:menu]
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					@pregnancy = Pregnancy.find(params[:pregnancy_id])
					# set_hoh_data()
				# end
				else
					@pregnancy = Pregnancy.find(params[:id])
				end

			# self.get_notes(arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id)
			@notes =nil # NotesService.get_notes(6150,session[:CLIENT_ID],6481,session[:CLIENT_ID])
		# end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when editing pregnancy details."
		redirect_to_back

	end

	def update
		# @client = Client.find(session[:CLIENT_ID])
		# @menu = nil
		# if params[:menu].present?
		# 	@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@pregnancy = Pregnancy.find(params[:pregnancy_id])
				# set_hoh_data()
			# end
			else
				@pregnancy = Pregnancy.find(params[:id])
			end
		@notes = params[:notes]
		l_params = pregnancy_params
		@pregnancy.pregnancy_due_date = l_params[:pregnancy_due_date]
		@pregnancy.number_of_unborn = l_params[:number_of_unborn]
		if @pregnancy.valid?
			ls_msg = PregnancyService.update_pregnancy(@pregnancy,params[:notes])
			if ls_msg == "SUCCESS"
				flash[:notice] = "Pregnancy information saved."
				if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
					redirect_to start_household_characteristics_data_entry_wizard_path
				else
					redirect_to show_pregnancy_path(@menu)
				end
			else
				flash[:notice] = ls_msg
				render :new
			end
		else
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating pregnancy details."
		redirect_to_back
	end

	def destroy
		# @client = Client.find(session[:CLIENT_ID])
		# @menu = nil
		# if params[:menu].present?
		# 	@menu = params[:menu]
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				@pregnancy = Pregnancy.find(params[:pregnancy_id])
				# set_hoh_data()
			# end
			else
				@pregnancy = Pregnancy.find(params[:id])
			end
		@pregnancy.destroy
		flash[:notice] = "Pregnancy information deleted."
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			redirect_to start_household_characteristics_data_entry_wizard_path
		else
			redirect_to show_pregnancy_path(@menu)
		end


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating pregnancy details."
		redirect_to_back
	end

   private
	def pregnancy_params
		params.require(:pregnancy).permit(:pregnancy_due_date,:number_of_unborn,:pregnancy_termination_date)
  	end

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
			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("PregnanciesController","get_client",err,current_user.uid)
				flash[:alert] = "Error ID: #{error_object.id} - Error when showing pregnancy details."
				redirect_to root_path
	end


end
