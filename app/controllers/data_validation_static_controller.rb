class DataValidationStaticController < AttopAncestorController

	# def data_validation_screen
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	#   if params[:selected_client].present?
	# 	# #logger.debug "session[@program_unit_id] = #{session[:PROGRAM_UNIT_ID].inspect}"
	# 	@client = Client.find(params[:selected_client])
	# 	# Rails.logger.debug("@client = #{@client.inspect}")+
	# 	#Rails.logger.debug("params[:wage_button] = #{params[:wage_button].inspect}")
	# 	if params[:ssi_button].present?
	# 		@client = Client.find(params[:selected_client])
	# 		@incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2707)
	# 		params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 		@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 		@navigate = "PROGRAM_UNIT_PROCESSING"
	# 		session[:NAVIGATE_FROM] = data_validation_screen_path
	# 		render :ssi_match
	# 	elsif params[:wage_button].present?
	# 			@client = Client.find(params[:selected_client])
	# 			@incomes = IncomeDetail.salary_income_type_income_record(params[:selected_client])
	# 			@ui_incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2847)
	# 			params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 			@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 			@navigate = "PROGRAM_UNIT_PROCESSING"
	# 			session[:NAVIGATE_FROM] = data_validation_screen_path
	# 			render :wage_ui_match
	# 	elsif params[:solq_button].present?
	# 			@client = Client.find(params[:selected_client])
	# 			params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 			@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 			render :solq_match
	# 	elsif params[:ocse_button].present?
	# 			@client = Client.find(params[:selected_client])
	# 			@incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2674)
	# 			params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 			@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 			@navigate = "PROGRAM_UNIT_PROCESSING"
	# 			session[:NAVIGATE_FROM] = data_validation_screen_path
	# 			render :ocse_match
	# 	elsif params[:wcomp_button].present?
	# 			@client = Client.find(params[:selected_client])
	# 			@incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2711)
	# 			params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 			@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 			@navigate = "PROGRAM_UNIT_PROCESSING"
	# 			session[:NAVIGATE_FROM] = data_validation_screen_path
	# 			render :wcomp_match
	# 	elsif params[:vital_button].present?
	# 			@client = Client.find(params[:selected_client])
	# 			@client_age = Client.get_age(@client.id)
	# 			params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 			@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 			parent_relationship = ClientRelationship.get_parent_collection_for_child(@client.id).first
	# 			parent = Client.find(parent_relationship.to_client_id)
	# 			if parent.last_name.present?
	# 				@parent_name = parent.last_name
	# 			end
	# 			if parent.first_name.present?
	# 				@parent_name = @parent_name + ' ' + parent.first_name
	# 			end
	# 			if parent.middle_name.present?
	# 			 @parent_name = @parent_name + ' ' + parent.middle_name
	# 			end
	# 			@parent_dob = parent.dob
	# 			render :vital_match
	# 	else
	# 		redirect_to_back
	# 	end
	#   else
	#     flash.now[:alert]= "Select a client."
	#     @focus_client = Client.find(session[:CLIENT_ID])
	# 	@client_program_unit = ProgramUnit.find(params[:program_unit_id])
	# 	params[:format] = 0
	# 	# validate
	# 	app_data_val_serv_obj = ApplicationDataValidationService.new
	# 	app_data_val_serv_obj.validate_program_unit_members_data_elements(@client_program_unit.id)
	# 	# show the results.
	# 	@failed_validations = DataValidation.get_program_unit_members_data_validation_results_to_be_corrected(@client_program_unit.id)
	# 	#list of clients in program unit
	# 	#Below variable @members  is used only for demo so can be removed when ever needed
	# 	@members = HouseholdMember.sorted_household_members_with_names(session[:HOUSEHOLD_ID])
	#     render '/data_validation/program_unit_data_validation_results'
	#     #program_unit_data_validation_results_path(params[:program_unit_id])
	#   end
	# end


	# def wage_ui_match
	# 	#Rails.logger.debug("params = #{params.inspect}")
	# 	@client = Client.find(params[:selected_client])
	# 	@incomes = IncomeDetail.salary_income_type_income_record(params[:selected_client])
	# 	@ui_incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2847)
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 	@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 	@navigate = "PROGRAM_UNIT_PROCESSING"
	# 	session[:NAVIGATE_FROM] = data_validation_screen_path

	# 	#session[:INCOME_DETAIL_ID] = @incomes.id
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
	# 	redirect_to_back
	# end

	# def osce_match
	# 	#Rails.logger.debug("params = #{params.inspect}")
	# 	@client = Client.find(params[:selected_client])
	# 	@incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2674)
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 	@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 	@navigate = "PROGRAM_UNIT_PROCESSING"
	# 	session[:NAVIGATE_FROM] = data_validation_screen_path

	# 	#session[:INCOME_DETAIL_ID] = @incomes.id
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
	# 	redirect_to_back
	# end

	# def wcomp_match
	# 	#Rails.logger.debug("params = #{params.inspect}")
	# 	@client = Client.find(params[:selected_client])
	# 	@incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2711)
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 	@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 	@navigate = "PROGRAM_UNIT_PROCESSING"
	# 	session[:NAVIGATE_FROM] = data_validation_screen_path

	# 	#session[:INCOME_DETAIL_ID] = @incomes.id
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
	# 	redirect_to_back
	# end

	# def vital_match
	# 	#Rails.logger.debug("params = #{params.inspect}")
	# 	@client = Client.find(params[:selected_client])
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 	@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 	@client_age = Client.get_age(@client.id)


	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
	# 	redirect_to_back
	# end

	# def solq_match
	# 	#Rails.logger.debug("params = #{params.inspect}")
	# 	@client = Client.find(params[:selected_client])
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 	@program_unit_id = session[:PROGRAM_UNIT_ID].to_i

	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
	# 	redirect_to_back
	# end

	# def ssi_income_match
	# 	#Rails.logger.debug("params = #{params.inspect}")
	# 	@client = Client.find(params[:selected_client])
	# 	@incomes = IncomeDetail.latest_client_income_detail_records(params[:selected_client],2707)
	# 	params[:program_unit_id] = session[:PROGRAM_UNIT_ID].to_i
	# 	@program_unit_id = session[:PROGRAM_UNIT_ID].to_i
	# 	@navigate = "PROGRAM_UNIT_PROCESSING"
	# 	session[:NAVIGATE_FROM] = data_validation_screen_path

	# 	#session[:INCOME_DETAIL_ID] = @incomes.id
	# rescue => err
	# 	error_object = CommonUtil.write_to_attop_error_log_table("IncomesController","income_summary",err,current_user.uid)
	# 	flash[:alert] = "Error ID: #{error_object.id} - Failed to view income summary for client."
	# 	redirect_to_back
	# end

end