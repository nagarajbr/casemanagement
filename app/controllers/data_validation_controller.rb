class DataValidationController < AttopAncestorController

	def index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_applications = ClientApplication.get_completed_applications_list(@client.id)
			@client_applications.each do |arg_app|
				arg_app.application_index_link_path = application_data_validation_results_path(arg_app.id)

			end
		end
		rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("DataValidationController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def program_unit_data_validation_index
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_program_units = ProgramUnit.get_client_program_units_list(@client.id)
				logger.debug "@client_program_units - inspect = #{@client_program_units.inspect} "
				@client_program_units.each do |arg_program_unit|
					arg_program_unit.index_link_path = program_unit_data_validation_results_path(arg_program_unit.id)
					logger.debug "arg_program_unit.index_link_path = #{arg_program_unit.index_link_path.inspect} "
				end
		end
     rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("DataValidationController","program_unit_data_validation_index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end

	def validation_results
		@focus_client = Client.find(session[:CLIENT_ID])
		@client_application = ClientApplication.find(params[:application_id])
		# validate
		app_data_val_serv_obj = ApplicationDataValidationService.new
		app_data_val_serv_obj.validate(params[:application_id])
		# show the results.
		@failed_validations = DataValidation.get_data_validation_results_to_be_corrected(params[:application_id].to_i)

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("DataValidationController","validation_results",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end



	def program_unit_data_validation_results
		# arg_program_unit_id = params[:program_unit_id]
		if session[:PRIMARY_APPLICANT].present?
			session[:CLIENT_ID] = session[:PRIMARY_APPLICANT]
		else
			# program_unit_members = ProgramUnitMember.get_primary_beneficiary(params[:program_unit_id])
			# if program_unit_members.present?
			# 	session[:CLIENT_ID] = program_unit_members.first.client_id
			# 	session[:PRIMARY_APPLICANT] = program_unit_members.first.client_id
			# end
			primary_contact = PrimaryContact.get_primary_contact(params[:program_unit_id], 6345)
			if primary_contact.present?
				session[:CLIENT_ID] = primary_contact.client_id
				session[:PRIMARY_APPLICANT] = primary_contact.client_id
			end
		end
		@focus_client = Client.find(session[:CLIENT_ID])
		@client_program_unit = ProgramUnit.find(params[:program_unit_id])
		# validate
		app_data_val_serv_obj = ApplicationDataValidationService.new
		app_data_val_serv_obj.validate_program_unit_members_data_elements(@client_program_unit.id)
		# show the results.
		@failed_validations = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@client_program_unit.id)
		#list of clients in program unit
		#Below variable @members  is used only for demo so can be removed when ever needed
		# @members = HouseholdMember.sorted_household_members_with_names(session[:HOUSEHOLD_ID])
		@members = ProgramUnitMember.sorted_program_unit_members(params[:program_unit_id])
		@incomes = IncomeDetail.salary_income_type_income_record(@focus_client.id).first
		participation =  ProgramUnitParticipation.get_participation_status(@client_program_unit).first
		# Rails.logger.debug("params[:format] = #{params[:format].inspect}")

		if participation.present?

			if params[:format] != '1'
				@pass = 'Pass'
			else
				if @incomes.present? && @incomes.date_received.to_s == '2015-12-01'
					@pass = 'Pass'
				else
					@pass = 'Fail'
				end
			end
		else
			if @incomes.present? && @incomes.date_received.to_s == '2015-12-01'
				@pass = 'Pass'
			else
				@pass = 'Fail'
				# client_name = Client.get_client_full_name_from_client_id(@focus_client.id)
				# program_unit = @client_program_unit.id
				# alert_text = "Wage verification with DWS failed for client : #{client_name}, in program unit : #{program_unit}"
				# Alert.set_alert(arg_alert_category,arg_alert_type,arg_alert_for_type,arg_alert_for_id,arg_alert_text,arg_status,arg_alert_assigned_to_user_id)
				# alert_new = Alert.set_alert(6348,2145,6345,program_unit,alert_text,6339,AuditModule.get_current_user.uid)
				# alert_new.save
			end
		end

		#ails.logger.debug("params[:format] = #{params[:format].inspect}")
		if params[:format] == '1'
			@verify_date = Date.today.strftime("%m/%d/%Y")
			@income_date = Date.today.strftime("%m/%d/%Y")
		elsif participation.present?
			@verify_date = participation.status_date.strftime("%m/%d/%Y")
			@income_date = participation.status_date.strftime("%m/%d/%Y")
		else
			@verify_date = Date.today.strftime("%m/%d/%Y")
			@income_date = Date.today.strftime("%m/%d/%Y")
		end

		# =====================================================================================================
		populate_summary_instance_variables()
		@current_user = AuditModule.get_current_user
		# what is the Role of the logged in user
		# If user role is supervisor or manager or system support or system Admin or Workload Manager
		# 1;"System Admin"
		# 2;"System Support"
		# 5;"Supervisor"
		# 6;"Manager"
		# 8;"Workload Manager"

			# Are there any pending Case Assignment task?
				if WorkTask.case_manager_assignment_task_pending_for_this_program_unit?(@selected_program_unit.id)
					@can_see_assign_case_manager_button = true

				else
					@can_see_assign_case_manager_button = false
				end


		if WorkTask.eligibility_worker_assignment_task_pending_for_this_program_unit?(@selected_program_unit.id)
			@can_see_assign_eligibility_worker_button = true

		else
			@can_see_assign_eligibility_worker_button = false
		end


		if @selected_program_unit.eligibility_worker_id.present?

			@can_see_start_button = true
		else
			@can_see_start_button = false
		end
		@program_unit_participation_status = ProgramUnitParticipation.get_program_unit_participation_status(@selected_program_unit.id)

		# =====================================================================================================

	rescue => err
	error_object = CommonUtil.write_to_attop_error_log_table("DataValidationController","program_unit_data_validation_results",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to access Invalid Client"
			redirect_to_back
	end




	def application_data_validation_correction_link

		session[:PRIMARY_APPLICANT] = session[:CLIENT_ID]
		session[:CLIENT_ID] = params[:client_id]
		logger.debug "session[:NAVIGATE_FROM]-inspect in data validations controller = #{session[:NAVIGATE_FROM].inspect}"

		# if params[:navigate] == "APPLICATION_SCREENING"
		# 	session[:NAVIGATE_FROM] = start_check_program_eligibility_wizard_path(params[:application_id])
		# elsif params[:navigate] == "SCREENING_SUMMARY"
		# 	session[:NAVIGATE_FROM] = view_screening_summary_path(params[:application_id])
		# else
		# 	# another- data validation results menu
		# 	session[:NAVIGATE_FROM] = application_data_validation_results_path(params[:application_id])
		# end

		case params[:navigate]
		when "APPLICATION_SCREENING"
			session[:NAVIGATE_FROM] = start_check_program_eligibility_wizard_path(params[:application_id])
		when "SCREENING_SUMMARY"
			session[:NAVIGATE_FROM] = view_screening_summary_path(params[:application_id])
		when "ASSESSMENT_SUMMARY"
			session[:NAVIGATE_FROM] = show_assessment_recommendations_path(session[:CLIENT_ASSESSMENT_ID])
		else
			session[:NAVIGATE_FROM] = application_data_validation_results_path(params[:application_id])
		end
		# logger.debug "session[:NAVIGATE_FROM]-inspect in data validations controller = #{session[:NAVIGATE_FROM].inspect}"
		case params[:validation_type].to_i
		when 6030 #"SSN"
			redirect_to edit_client_path
		when 6031 #"RESIDENCY"
			redirect_to show_alien_path
		when 6032 # "DOB"
			redirect_to edit_client_path
		when 6033 # "ADDRESS"
			redirect_to show_address_path
		when 6034 # "WORK REGISTRATION"
			redirect_to index_client_characteristic_path("clients", "work")
		when 6775 # "Learning Difficulty Screening"
			redirect_to edit_common_assessment_path(13,session[:CLIENT_ASSESSMENT_ID])
		when 6776 # "Career Interests"
			redirect_to interest_profiler_question_wizard_initialize_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("DataValidationController","application_data_validation_correction_link",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back

	end

	def program_unit_data_validation_correction_link


		session[:PRIMARY_APPLICANT] = session[:CLIENT_ID]
		session[:CLIENT_ID] = params[:client_id]
		logger.debug "session[:NAVIGATE_FROM]-inspect in data validations controller = #{session[:NAVIGATE_FROM].inspect}"

		if params[:navigate] == "PROGRAM_UNIT_PROCESSING"
			session[:NAVIGATE_FROM] = edit_program_unit_wizard_path(params[:program_unit_id])
		elsif params[:navigate] == "PROGRAM_UNIT_SUMMARY"
			session[:NAVIGATE_FROM] = view_program_unit_summary_path(params[:program_unit_id])
		elsif params[:navigate] == "PROGRAM_UNIT_OVERWRITE"
			session[:NAVIGATE_FROM] = start_overwrite_wizard_path(params[:program_unit_id])
		else
			# another- data validation results menu
			session[:NAVIGATE_FROM] = program_unit_data_validation_results_path(params[:program_unit_id])
		end
		logger.debug "session[:NAVIGATE_FROM]-inspect in data validations controller = #{session[:NAVIGATE_FROM].inspect}"
		case params[:validation_type].to_i
			when 6030 # "SSN"
				redirect_to edit_client_path
			when 6031 # "RESIDENCY"
				redirect_to show_alien_path
			when 6032 # "DOB"
				redirect_to edit_client_path
			when 6033 # "ADDRESS"
				redirect_to show_address_path
			when 6034 # "WORK REGISTRATION"
				redirect_to index_client_characteristic_path( "clients", "work")

			when 6051 #  "EDUCATION"
				redirect_to educations_path("CLIENT")
			end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("DataValidationController","program_unit_data_validation_correction_link",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid client."
		redirect_to_back
	end



	private
		def populate_summary_instance_variables()

  	 		#1. Program Unit
			# 2. Program Unit Members
			# 3. Program Unit member relationship
			# 4.Program Unit Data Verification Results
			# 5. Program Unit Document Verification Results
			# 6. Program Unit Screening Results
			# 7.Program Participation Status
			@selected_program_unit = ProgramUnit.find(params[:program_unit_id])
			# Manoj 04/22/2015
			# When Navigated from My Program Units there will not be Client_id in the session - hence logically setting the correct client id in the session.
			if session[:CLIENT_ID].present?
				@client = Client.find(session[:CLIENT_ID])
			else
				# find the self of program unit & if it is not yet poplated - find the primary applicant
				# and populate session[:CLIENT_ID]

				# primary_member_collection = ProgramUnitMember.get_primary_beneficiary(@selected_program_unit.id)
				# if primary_member_collection.present?
				# 	self_of_pgu_object = primary_member_collection.first
				# 	session[:CLIENT_ID] = self_of_pgu_object.client_id
				# else
				# 	# find primary Applicant
				# 	primary_applicant_collection = ApplicationMember.get_primary_applicant(@selected_program_unit.client_application_id)
				# 	primary_applicant_object = 	primary_applicant_collection.first
				# 	session[:CLIENT_ID] = primary_applicant_object.client_id
				# end

				primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.id, 6345)
				if primary_contact.blank?
					primary_contact = PrimaryContact.get_primary_contact(@selected_program_unit.client_application_id, 6587)
				end
				if primary_contact.present?
					session[:CLIENT_ID] = primary_contact.client_id
				end
				@client = Client.find(session[:CLIENT_ID])
			end



			# Initialize the Session Variable -start - Manoj 10/09/2014
			session[:PROGRAM_UNIT_ID] = @selected_program_unit.id
			# Initialize the Session Variable -start
			@client_application = ClientApplication.find(@selected_program_unit.client_application_id)
			@program_unit_members = ProgramUnitMember.sorted_program_unit_members(@selected_program_unit.id)
			@client_relationships = ClientRelationship.get_program_unit_member_relationships(@selected_program_unit.id)
			# Call Data Validation Service Object.
      		application_srvc_object = ApplicationDataValidationService.new
			application_srvc_object.validate_program_unit_members_data_elements(@selected_program_unit.id)
			# get records from Datavalidation table for selected application ID
			@data_validation_results = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@selected_program_unit.id)
			# @data_validation_results = DataValidation.get_data_validation_results(@client_application.id)
			@client_doc_verification_list = ClientDocVerfication.get_program_unit_verified_documents(@selected_program_unit.id)


			fts = FamilyTypeService.new
			@family_type_struct = FamilyTypeStruct.new
			@family_type_struct = fts.determine_family_type_for_program_unit(@selected_program_unit.id)
			@family_type_struct.application_date = @client_application.application_date
			# @case_type = @family_type_struct.case_type
			@case_type = CodetableItem.get_short_description(@selected_program_unit.case_type)
			if DataValidation.are_all_the_date_validations_complete(@selected_program_unit.id, "PU")
				appl_eligibilty_servc = ApplicationEligibilityService.new
				#appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
				appl_eligibilty_servc.determine_program_unit_eligibilty(@family_type_struct)

				# @app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@client_application.id)
				@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list_based_on_program_unit_id(session[:PROGRAM_UNIT_ID].to_i)

			end

			@program_participations = @selected_program_unit.program_unit_participations.order("id DESC")
  	 	end
end


