class ClientAssessmentHistoriesController < AttopAncestorController
	def index
		@client = Client.find(session[:CLIENT_ID].to_i)
		@client_assessment_histories = ClientAssessmentHistory.get_client_assessment_histories(@client.id)
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentHistoriesController","index",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to show assessment history."
			redirect_to_back
	end

	def show
		@client = Client.find(session[:CLIENT_ID])
		@assessed_sections_with_barriers = ClientAssessmentHistory.get_assessed_sections_with_barriers_from_history(params[:id])
		@assessed_sub_sections_with_strengths = ClientAssessmentHistory.get_assessed_sub_sections_with_strengths_from_history(params[:id])
		@assessment_barriers_history = AssessmentBarrierHistory.get_assessment_barriers_history(params[:id])
		@report_detail_data_history = AssessmentBarrierRecommendationHistory.get_history_report_detail_data(params[:id])
		logger.debug("@report_detail_data_history = #{@report_detail_data_history.inspect}")
		@assessment_strengths_history = AssessmentStrengthHistory.get_assessment_strengths_history(params[:id])
		onet_ws = OnetWebService.new("arwins","9436zfu")
		assessment_career = AssessmentCareer.get_latest_assessment_career(@client.id)
		if assessment_career.present?
			@Occupational_goal  = onet_ws.get_code_description(assessment_career.career_code,"careers","career")
		else
			@Occupational_goal  = " "
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentHistoriesController","show",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to show assessment history."
			redirect_to_back
	end
end
