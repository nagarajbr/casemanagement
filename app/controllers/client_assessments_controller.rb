class ClientAssessmentsController < AttopAncestorController



	def complete_assessment
		ls_msg = "SUCCESS"
		# tabe_and_ld_score_check = ClientAssessment.check_if_TABE_and_LD_scores_are_present(params[:id],session[:PROGRAM_UNIT_ID])

		# if tabe_and_ld_score_check == "SUCCESS"
			# fail
			@client_assessment = ClientAssessment.find(params[:id])
			@client_assessment.assessment_date = Date.today
			@client_assessment.assessment_status = 6264

			# event to action management
			# 1. Move PGU from Assessment Queue to Employment Planning Queue
			# 2. complete Assessment Task
			# step1 : Populate common event management argument structure
			common_action_argument_object = CommonEventManagementArgumentsStruct.new
	        common_action_argument_object.event_id = 662 #  Complete Assessment button
	        common_action_argument_object.client_id = @client_assessment.client_id

	        # Queue related variables.

	        #  Find Program unit for the client.
	        step1 = ProgramUnitMember.joins(" INNER JOIN program_units
	        	                            ON (program_unit_members.program_unit_id = program_units.id
	        	                                and program_units.service_program_id != 17)")
	        step2 = step1.where("program_unit_members.client_id = ?",@client_assessment.client_id)
	        # program_member_collection = ProgramUnitMember.where("client_id = ?", @client_assessment.client_id)
	        program_member_collection = step2
			begin
				ActiveRecord::Base.transaction do

					# if ls_msg == "SUCCESS"
						@client_assessment.save!
						ls_msg = ClientAssessmentHistory.save_client_assessment_history_tables_one_transaction(params[:id])

						if ls_msg == "SUCCESS"
							# Manoj 02/18/2015 - Managae EmploymentReadinessPlan start
							EmploymentReadinessPlan.save_employment_readiness_pan(@client_assessment.id)
							# Manoj 02/18/2015 - End
							# flash[:notice] = "Assessment is Completed."
							# redirect_to client_assessment_histories_path
						else
							# flash[:alert] = ret_hash["msg"]
							flash[:alert] = ls_msg
							redirect_to show_assessment_recommendations_path(session[:CLIENT_ASSESSMENT_ID].to_i)
						end
					# end

					if ls_msg == "SUCCESS"

						# process event to action mapping here
						if program_member_collection.present?
				        	program_member_object = program_member_collection.order("program_unit_id DESC").first

				        	common_action_argument_object.queue_reference_type = 6345 # program unit
				    		common_action_argument_object.queue_reference_id = program_member_object.program_unit_id
				    		common_action_argument_object.program_unit_id = program_member_object.program_unit_id
				    		ls_msg = EventManagementService.process_event(common_action_argument_object)
				    		if ls_msg == "SUCCESS"
				    			flash[:notice] = "Assessment is Completed."
								redirect_to client_assessment_histories_path
				    		else
				    			flash[:alert] = ls_msg
								redirect_to show_assessment_recommendations_path(session[:CLIENT_ASSESSMENT_ID].to_i)
				    		end
				        else
				        	# Only assessment - not associated with program unit yet
				        	flash[:notice] = "Assessment is complete."
							redirect_to client_assessment_histories_path
				        end
					end

				end # end of transaction
			rescue => err
		  		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentsController","complete_assessment",err,AuditModule.get_current_user.uid)
		  		ls_msg = "Failed to complete assessment- for more details refer to Error ID: #{error_object.id}."
		  		flash[:alert] = ls_msg
		  		redirect_to show_assessment_recommendations_path(session[:CLIENT_ASSESSMENT_ID].to_i)
			end
		# else
			# session[:COMPLETE_ASSESSMENT_ERROR_MESSAGE] = tabe_and_ld_score_check
		 	# redirect_to show_assessment_recommendations_path(params[:id])
		# end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentsController","complete_assessment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to complete assessment."
		redirect_to_back
	end

	def withdraw_assessment
         @client_assessment = ClientAssessment.find(params[:id])
         @assessment_object = @client_assessment
         @client = Client.find(session[:CLIENT_ID])
         rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentsController","withdraw_assessment",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to withdraw assessment."
			redirect_to_back
    end

    def withdraw_assessment_save
	    @client_assessment = ClientAssessment.find(params[:id])
	    @client_assessment.assessment_status = 6365
	    begin
			ActiveRecord::Base.transaction do
				@client_assessment.save!
				ls_msg = ClientAssessmentHistory.save_client_assessment_history_tables_one_transaction(params[:id])

				if ls_msg == "SUCCESS"
					redirect_to client_assessment_histories_path
				else
					# flash[:alert] = ret_hash["msg"]
					flash[:alert] = ls_msg
					redirect_to show_assessment_recommendations_path(session[:CLIENT_ASSESSMENT_ID].to_i)
				end
		    end
		end
	    rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentsController","withdraw_assessment_save",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to withdraw assessment."
			redirect_to_back

    end

    def selected_sections_for_short_assessment
    	# result = ActionPlanDetail.is_there_an_assessment_activity_created_for_the_client(session[:CLIENT_ID], session[:PROGRAM_UNIT_ID])
    	# Rails.logger.debug("result = #{result}")
    	# fail
    	if assessment_plan_not_required
			step1 = AssessmentSection.joins("INNER JOIN system_params on system_params.key = 'SHORT_ASSESSMENT_SECTIONS'")
	    	step2 = step1.select("distinct system_params.id,system_params.value,system_params.description")
	    	step3 = step2.order("id")
	    	@short_assessment_sections = step3
	    	@defaulted_list = []
	    	@client_name = Client.get_client_full_name_from_client_id(session[:CLIENT_ID])
	    	if session[:PROGRAM_UNIT_ID].present?
	    		@program_unit_object = ProgramUnit.find(session[:PROGRAM_UNIT_ID])
	    		adult = Client.is_adult(session[:CLIENT_ID])
	    		if @program_unit_object.service_program_id == 1 and @program_unit_object.case_type == 6046 and adult
	    			@defaulted_list = ["3","18","2"]
	    		elsif @program_unit_object.service_program_id == 1 and @program_unit_object.case_type == 6047 and adult
	    			@defaulted_list = ["3","18","6","2"]
	    		elsif @program_unit_object.service_program_id == 1 and @program_unit_object.case_type == 6049 and adult == false
	    			@defaulted_list = ["3","18"]
	    		elsif @program_unit_object.service_program_id == 1
	    			@defaulted_list = ["18"]
	    		elsif @program_unit_object.service_program_id == 4 and (@program_unit_object.case_type == 6046 || @program_unit_object.case_type == 6047) and adult
	    			@defaulted_list = ["2"]
	    		end
	    		if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].present?
	    			@defaulted_list = session[:SELECTED_SECTIONS_FOR_ASSESSMENT]
	    		end
	    	else
	    		if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].present?
	    			@defaulted_list = session[:SELECTED_SECTIONS_FOR_ASSESSMENT]
	    		end
	    	end

		else
			session[:NAVIGATE_FROM] = selected_sections_for_short_assessment_path(session[:CLIENT_ID])
			redirect_to assessment_activity_path
		end

    rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentsController","selected_sections_for_short_assessment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to start assessment."
		redirect_to_back
    end

    def process_selected_sections_for_short_assessment
    	if params[:selected_assessment_sections].present?
    		session[:SELECTED_SECTIONS_FOR_ASSESSMENT] = params[:selected_assessment_sections]
	    	first_selected_section = session[:SELECTED_SECTIONS_FOR_ASSESSMENT].first
	    	first_sub_section_id = ClientAssessment.get_first_subsection_id_for_selected_section(first_selected_section)
	    	if first_sub_section_id == "/ASSESSMENT/client_scores"
	    		redirect_to("/ASSESSMENT/client_scores")
	    	elsif first_sub_section_id == "/ASSESSMENT/work/characteristics/index"
	    		redirect_to("/ASSESSMENT/work/characteristics/index")
	    	elsif first_sub_section_id == "/ASSESSMENT/mental/characteristics/index"
	    		redirect_to("/ASSESSMENT/mental/characteristics/index")
	    	elsif first_sub_section_id == "/ASSESSMENT/substance_abuse/characteristics/index"
	    		redirect_to("/ASSESSMENT/substance_abuse/characteristics/index")
	    	elsif first_sub_section_id == "/ASSESSMENT/domestic/characteristics/index"
	    		redirect_to("/ASSESSMENT/domestic/characteristics/index")
	    	elsif first_sub_section_id == "/ASSESSMENT/clients/medical_pregnancy/show"
	    		redirect_to("/ASSESSMENT/clients/medical_pregnancy/show")
	    	else
	    		redirect_to edit_common_assessment_path(first_sub_section_id.to_i,session[:CLIENT_ASSESSMENT_ID].to_i)
	    	end
    	else
    		redirect_to selected_sections_for_short_assessment_path(session[:CLIENT_ID]), alert: "Select atleast one factor to start assessment process."
    	end
    	rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentsController","process_selected_sections_for_short_assessment",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Attempted to create short assessment"
			redirect_to_back
    end

end
