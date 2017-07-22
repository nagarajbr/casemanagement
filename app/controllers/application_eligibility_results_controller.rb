class ApplicationEligibilityResultsController < AttopAncestorController

	def index
		#  show completed Applications to process -Screening
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_applications = ClientApplication.get_completed_applications_list(@client.id)
			if @client_applications.present?
				@client_applications.each do |arg_appln|
					app_srvc_prgm_collection = ApplicationServiceProgram.get_application_service_program_object(arg_appln.id)
					if app_srvc_prgm_collection.present?
						arg_appln.selected_service_program = app_srvc_prgm_collection.first.service_program_id
					end
					arg_appln.application_index_link_path = show_application_screening_result_path(arg_appln.id)
				end
			end
		end
       rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationEligibilityResultsController","index",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when list of screening results."
		redirect_to_back
	end

	def show
		@client = Client.find(session[:CLIENT_ID].to_i)
		@selected_application = ClientApplication.find(params[:application_id].to_i)
		fts = FamilyTypeService.new
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct = fts.determine_family_type(@selected_application.id)
		@case_type = @family_type_struct.case_type
		@family_type_struct.application_date = @selected_application.application_date # Code changes done for ABM-303 -Kiran 03/17/2015
		if DataValidation.are_all_the_date_validations_complete(@selected_application.id, "APP")
			appl_eligibilty_servc = ApplicationEligibilityService.new
			appl_eligibilty_servc.determine_application_eligibilty(@family_type_struct)
			@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationEligibilityResultsController","show",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when list of screening results."
		redirect_to_back
	end


	def index_client_program_unit_for_screening_results
		if session[:CLIENT_ID].present?
			@client = Client.find(session[:CLIENT_ID].to_i)
			@client_program_units = ProgramUnit.get_client_program_units_list(@client.id)
			if @client_program_units.present?
				# logger.debug "@client_program_units - inspect = #{@client_program_units.inspect} "
				@client_program_units.each do |arg_program_unit|
					arg_program_unit.index_link_path = show_program_unit_screening_result_path(arg_program_unit.id)
					# logger.debug "arg_program_unit.index_link_path = #{arg_program_unit.index_link_path.inspect} "
				end
			end
		end

      rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationEligibilityResultsController","index_client_program_unit_for_screening_results",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when list of screening results."
		redirect_to_back
	end

	def show_program_unit_screening_result
		@client = Client.find(session[:CLIENT_ID].to_i)
		@selected_program_unit = ProgramUnit.find(params[:program_unit_id].to_i)
		@selected_application = ClientApplication.find(@selected_program_unit.client_application_id)
		fts = FamilyTypeService.new
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct = fts.determine_family_type_for_program_unit(@selected_program_unit.id)
		@family_type_struct.application_date = @selected_application.application_date
		@case_type = @family_type_struct.case_type
		if DataValidation.are_all_the_date_validations_complete(@selected_program_unit.id, "PU")
			appl_eligibilty_servc = ApplicationEligibilityService.new
			appl_eligibilty_servc.determine_program_unit_eligibilty(@family_type_struct)
			# @app_elig_rslts = ApplicationEligibilityResults.get_the_results_list(@selected_application.id)
			@app_elig_rslts = ApplicationEligibilityResults.get_the_results_list_based_on_program_unit_id(@selected_program_unit.id)
		end

		if @selected_program_unit.case_type != @family_type_struct.case_type_integer
				# Save new case type
				# save that case type in Application screening table.
				@selected_program_unit.case_type = @family_type_struct.case_type_integer
				@selected_program_unit.save

		end
	end
   rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ApplicationEligibilityResultsController","show_program_unit_screening_result",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} -  Error when showing the screening results."
		redirect_to_back
end