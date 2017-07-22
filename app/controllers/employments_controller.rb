class EmploymentsController < AttopAncestorController
	# Author : Manoj Patil
	# Date : 08/08/2014
	# Description: CRUD operation for Model - Employment.
	# Modifications :Keerthan 04/15/2015
	# Modification Description : Employer Name is dropdown from Employers table -
	# Modifications :Manoj 11/20/2015
	# Modification Description : called from Household member steps.

	def new
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@employment = @client.employments.new
		@employer_list = Employer.all
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
		# Manoj 11/20/2015 - called from Household member step
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end

		@employment_income_types = CodetableItem.get_code_table_values_by_system_params('INCOME_TYPE_SALARY_WAGES')
		# default
		@employment.income_type = 2811 # salary /wages
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","new",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back # that is default page for Employment -
	end

	def create
		@employment_income_types = CodetableItem.get_code_table_values_by_system_params('INCOME_TYPE_SALARY_WAGES')
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@employment = @client.employments.new(params_values)
		@employer_list = Employer.all
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end

		ls_msg = nil
		begin
            ActiveRecord::Base.transaction do
				if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(@client.id)
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.client_id = @client.id
			        common_action_argument_object.model_object = @employment
			        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(@client.id)
			        common_action_argument_object.changed_attributes = @employment.changed_attributes().keys
			        common_action_argument_object.is_a_new_record = @employment.new_record?
			        common_action_argument_object.run_month = @employment.effective_begin_date
			        @employment.save!
					ls_msg = EventManagementService.process_event(common_action_argument_object)
				else
					if @employment.valid?
						 if @employment.save!
							ls_msg = "SUCCESS"
						else
							ls_msg = "Cannot create employment information."
						end
					else
						render :new
					end
				end
				if params[:notes].present?
					NotesService.save_notes(6150,session[:CLIENT_ID],6488,@employment.id,params[:notes])
				end
			end
		rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","create",err,AuditModule.get_current_user.uid)
	          	ls_msg = "Failed to create employment information - for more details refer to error ID: #{error_object.id}."
		end

		if ls_msg == "SUCCESS"

			flash[:notice] = "Employment information saved."
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				session[:HOUSEHOLD_MEMBER_REGISTRATION_STEP] = 'household_member_employments_step'
				redirect_to start_household_member_registration_wizard_path
			else
				# before hhmember step process
				if session[:NAVIGATE_FROM].blank?
					redirect_to employment_url(@menu,@employment.id)
				else
					navigate_back_to_called_page()
			    end
			end
		else
			@client = Client.find(session[:CLIENT_ID])
			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
			if @employment.errors.full_messages.blank?
				flash.now[:alert] = ls_msg
			end
			render :new
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","create",err,current_user.uid)
		flash[:alert] = "Failed to create employment information - for more details refer to error ID: #{error_object.id}."
		redirect_to_back

	end

	def index
		@menu = params[:menu]

		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID])
			l_records_per_page = SystemParam.get_pagination_records_per_page
			@employment = @client.employments.page(params[:page]).per(l_records_per_page)

			if session[:CLIENT_ASSESSMENT_ID].present?
				@assessment_id = session[:CLIENT_ASSESSMENT_ID].to_i
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
					@client_assessment.current_step = "/ASSESSMENT/employments"
					session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step
					# clients_age = Client.get_age(session[:CLIENT_ID])
     #                 if clients_age != -1
	    #                 li_adult_age = SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
	    #                 if clients_age < li_adult_age
		   #                flash.now[:alert]= "Assessment is required only for adults and minor parents, this client's age is #{clients_age}."
	    #                 end
     #                 end
				end
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def show
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@employment = Employment.find(params[:employment_id])
		@employer_name = Employer.get_employer_name(@employment.employer_id).first.employer_name if Employer.get_employer_name(@employment.employer_id).present?
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end
		@notes = NotesService.get_notes(6150,session[:CLIENT_ID],6488,@employment.id)
		# Rails.logger.debug("@notes = #{@notes.inspect}")
		# fail
		l_records_per_page = SystemParam.get_pagination_records_per_page
		@notes = @notes.page(params[:page]).per(l_records_per_page) if @notes.present?
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employment record."
		redirect_to_back
	end

	def edit
		@employment_income_types = CodetableItem.get_code_table_values_by_system_params('INCOME_TYPE_SALARY_WAGES')
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@employment = Employment.find(params[:employment_id])
		@employer_list = Employer.all
		if session[:CLIENT_ASSESSMENT_ID].present?
			if session[:CLIENT_ASSESSMENT_ID].to_i != 0
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				@assessment_object = @client_assessment
			end
		end

		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","edit",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employment record."
		redirect_to_back
	end

	def update
		@employment_income_types = CodetableItem.get_code_table_values_by_system_params('INCOME_TYPE_SALARY_WAGES')
		@menu = params[:menu]
		@employment = Employment.find(params[:employment_id])
		@client = Client.find(session[:CLIENT_ID])
		@employer_list = Employer.all
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end
		@employment.assign_attributes(params_values)
		ls_msg = nil
		begin
            ActiveRecord::Base.transaction do
				if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(@client.id)
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
			        common_action_argument_object.client_id = @client.id
			        common_action_argument_object.model_object = @employment
			        common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(@client.id)
			        common_action_argument_object.changed_attributes = @employment.changed_attributes().keys
			        common_action_argument_object.is_a_new_record = @employment.new_record?
			        common_action_argument_object.run_month = @employment.effective_begin_date
			        @employment.save!
					ls_msg = EventManagementService.process_event(common_action_argument_object)
				else
					if @employment.valid?
						 if @employment.save!
							ls_msg = "SUCCESS"
						else
							ls_msg = "Cannot create employment information."
						end
					else
						ls_msg = "Cannot create employment information."
						render :edit
					end
				end
				if params[:notes].present?
					NotesService.save_notes(6150,session[:CLIENT_ID],6488,@employment.id,params[:notes])
				end
			end
		rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","update",err,AuditModule.get_current_user.uid)
	          	ls_msg = "Failed to update employment information - for more details refer to error ID: #{error_object.id}."
		end

		if ls_msg == "SUCCESS" || ls_msg.blank?
			flash[:notice] = "Employment information saved"
			if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
				redirect_to start_household_member_registration_wizard_path
			else
				# before hhmember step process
				if session[:NAVIGATE_FROM].blank?
					redirect_to employment_url(@menu,@employment.id)
				else
					navigate_back_to_called_page()
			    end
			end
		else

			if session[:CLIENT_ASSESSMENT_ID].present?
				if session[:CLIENT_ASSESSMENT_ID].to_i != 0
					@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
					@assessment_object = @client_assessment
				end
			end
			if @employment.errors.full_messages.blank?
				flash.now[:alert] = ls_msg
			end
			render :edit
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","update",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error when updating employment details."
		redirect_to_back
	end

	def destroy
		@menu = params[:menu]
		@client = Client.find(session[:CLIENT_ID])
		@employment = Employment.find(params[:employment_id])
		if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
			set_hoh_data(@client.id)
		end
		income_collection = Income.where("employment_id = ?",@employment.id)
		if income_collection.present?
			 flash[:alert] = "Employer information cannot deleted, because dependent income information found."
		else
			employment_details_collection = EmploymentDetail.where("employment_id = ?",@employment.id)
			if employment_details_collection.present?
				flash[:alert] = "Employer information cannot deleted, because dependent employment detail information found."
			else
				@employment.destroy
				 flash[:alert] = "Employer information deleted."
			end
		end

		 if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		 	redirect_to start_household_member_registration_wizard_path
		 else
			redirect_to employments_path(@menu)
		 end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentsController","destroy",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid employment record."
		redirect_to_back
	end


	def navigate_to_employer_creation_page
		 # Navigate to employer creation page where new employer will be created- this is used when user does not find his employer in the dropdown.
		 @menu = params[:menu]
		 if @menu == 'HOUSEHOLD_MEMBER_STEP_WIZARD'
		 	session[:NAVIGATE_FROM] = new_household_member_employment_path(session[:CLIENT_ID].to_i,'HOUSEHOLD_MEMBER_STEP_WIZARD')
		 	 # start_household_member_registration_wizard_path
		 else
		 	session[:NAVIGATE_FROM] = new_employment_path
		 end
		redirect_to new_employer_path
	end


	private

		def params_values
	  		params.require(:employment).permit(:effective_begin_date,:effective_end_date,
	  									   :position_title,:duties,:leave_reason,:employment_level,:placement_ind,
	  									   :health_ins_covered,:occupation_code,:employer_id,:income_type
	  									 )
	  	end

	  	# Manoj 11/20/2015
	 #  	def set_employment_hoh_data(arg_client_id)
		# 	set_hoh_data(arg_client_id)
		# 	@income_id =  params[:income_id].to_i
		# end
end
