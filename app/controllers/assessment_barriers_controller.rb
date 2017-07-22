class AssessmentBarriersController < AttopAncestorController
	# Manoj Patil 01/30/2014

	def show_assessment_recommendations
		@client = Client.find(session[:CLIENT_ID])
		app_data_val_serv_obj = ApplicationDataValidationService.new
		app_data_val_serv_obj.assessment_validations(session[:CLIENT_ID], session[:PROGRAM_UNIT_ID], session[:CLIENT_ASSESSMENT_ID])
		@assessment_validation_results = DataValidation.get_assessment_validations_to_be_fixed(session[:CLIENT_ID]) if session[:PROGRAM_UNIT_ID].present?
		if @assessment_validation_results.present?
			# Rails.logger.debug("@assessment_validation_results = #{@assessment_validation_results.inspect}")
			# fail
			if session[:APPLICATION_ID].present?
				application_id = session[:APPLICATION_ID]
			elsif session[:PROGRAM_UNIT_ID].present? && session[:PROGRAM_UNIT_ID] != 0
				application_id = ProgramUnit.find(session[:PROGRAM_UNIT_ID]).client_application_id
			end
			@application = ClientApplication.find_by_id(application_id)
		else
			if assessment_plan_not_required
				# Rule 1: If assessment is complete - show record from table - else compute and save the record into table.
				l_assessment_id = params[:assessment_id].to_i
				if l_assessment_id.to_i == 0
					# No assessment questions have been answered - so send him back to short assessment page.
					redirect_to selected_sections_for_short_assessment_path(@client.id)
				else
					@assessment_object = ClientAssessment.find(l_assessment_id)
					onet_ws = OnetWebService.new("arwins","9436zfu")
					assessment_career = AssessmentCareer.get_latest_assessment_career(@client.id)
					if assessment_career.present?
						@action_plan_short_term_goals = onet_ws.get_code_description(assessment_career.career_code,"careers","career")
					else
						@action_plan_short_term_goals = " "
					end

					if @assessment_object.assessment_status == 6264 # complete
					   @assessment_object.assessment_status = 6265 # Make Incompele when Generate Assessement is clicked
					   @assessment_object.save
					else
						#Assessment is Incomplete - so delete & Insert
						AssessmentBarrier.where("client_assessment_id = ?",l_assessment_id).destroy_all
			    		AssessmentBarrierDetail.where("assessment_barrier_id in (select id from assessment_barriers where client_assessment_id = ?) ",l_assessment_id).destroy_all
			    		AssessmentBarrierRecommendation.where("client_assessment_id = ?",l_assessment_id).destroy_all
			    		AssessmentStrength.where("client_assessment_id = ?",l_assessment_id).destroy_all

						# Process the barrier and recommendations
						AssessmentService.process_assessment_education_barriers(l_assessment_id,@client.id)
						AssessmentService.process_assessment_employment_barriers(l_assessment_id)
						AssessmentService.process_assessment_housing_barriers(l_assessment_id)
						AssessmentService.process_assessment_transportation_barriers(l_assessment_id)
						AssessmentService.process_assessment_general_health_barriers(l_assessment_id)
						AssessmentService.process_assessment_mental_health_barriers(l_assessment_id)
						AssessmentService.process_assessment_substance_abuse_barriers(l_assessment_id)
						AssessmentService.process_assessment_domestic_voilence_barriers(l_assessment_id)
						# AssessmentService.process_assessment_finance_barriers(l_assessment_id)
						AssessmentService.process_assessment_pregnancy_barriers(l_assessment_id)
						AssessmentService.process_assessment_child_care(l_assessment_id)
						AssessmentService.process_assessment_strengths(l_assessment_id,@client.id)
					end
					# View related Instance Variables

					@assessed_sections_with_barriers = AssessmentSection.get_assessed_sections_with_barriers(l_assessment_id)
					@assessment_barriers = AssessmentBarrier.get_assessment_barriers(l_assessment_id)
					@report_detail_data = AssessmentBarrierRecommendation.get_report_detail_data(l_assessment_id)

					@assessed_sub_sections_with_strengths = AssessmentSection.get_assessed_sub_sections_with_strengths(l_assessment_id)
					@assessment_strengths = AssessmentStrength.get_assessment_strengths(l_assessment_id)
					if session[:COMPLETE_ASSESSMENT_ERROR_MESSAGE].present?
						@assessment_object.errors[:base] << session[:COMPLETE_ASSESSMENT_ERROR_MESSAGE]
						session[:COMPLETE_ASSESSMENT_ERROR_MESSAGE] = nil
					end
				end
			else
				session[:NAVIGATE_FROM] = show_assessment_recommendations_path(params[:assessment_id].to_i)
				redirect_to assessment_activity_path
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("AssessmentBarriersController","show_assessment_recommendations",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when generating recommendations report."
		redirect_to_back # that is default page for Assessment
	end
end