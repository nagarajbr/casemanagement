class InterestProfilerQuestionsController <  AttopAncestorController
 	def interest_profiler_question_wizard_initialize
  		session[:INTEREST_PROFILER_QUESTION_STEP] = nil
  		session[:back] = nil
  		session[:INPUT_RESULT] = nil
  		redirect_to start_interest_profiler_question_wizard_path
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InterestProfilerQuestionsController","interest_profiler_question_wizard_initialize",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Failed to start wizard."
		redirect_to_back
	end

    def start_interest_profiler_question_wizard

		@client_assessment = ClientAssessment.new
	  	@client_assessment.interest_profiler_current_step = session[:INTEREST_PROFILER_QUESTION_STEP]
	  	case @client_assessment.interest_profiler_current_step
	  	when "interest_profiler_first"
	  		@step_number = "Step 1 of 4"
	  		# @header_desc = "Identify career goals"
	  		@questions = ["Interest Profiler","Education and Employment History"]
	  		@answer = session[:back]
	  		# session[:back] = nil
	  	when "interest_profiler_second"
	   		@step_number = "Step 2 of 4"
	  		@header_desc = "Career Interest Profiler Questions"
	  		@questions = CodetableItem.item_list_id(203,"")
	  		@selected_dropdown_values = session[:INPUT_RESULT]
	  	when "interest_profiler_third"
	  		if session[:back] == "Education and Employment History"
                #get all occupations provided by DWS providers if the client does not have any employment history
                @step_number = "Step 3 of 4"
		  		@header_desc = "Careers that fit your interests and preparation level (click below for details/select):"
		  		@zone_results = []
                onet_ws = OnetWebService.new("arwins","9436zfu")
                occupations = Employment.employment_list_for_client(session[:CLIENT_ID])
                program_unit_id = ProgramUnit.get_latest_program_unit_id_for_the_client(session[:CLIENT_ID])

             #    if program_unit_id.present?
             #    else
             #    	program_unit_id =  -1
            	# end

                if occupations.present?
                	#occupations += ProviderService.provider_occupations_lits()
                	occupations += Provider.providers_with_approved_agreement_and_for_a_location(program_unit_id)
                else
                	occupations = Provider.providers_with_approved_agreement_and_for_a_location(program_unit_id)
	               	#occupations = ProviderService.provider_occupations_lits()
                end

                Rails.logger.debug ("occupations----->#{occupations.inspect}")

                if occupations.present?
	              	 occupations.each do |occupation|
	                  zone_result = onet_ws.career_intrests_by_code_or_keyword(occupation.occupation)
	                  # Insert only when Onet returns a valid occupation infomation
	                	if zone_result["careers"].present? && zone_result["careers"]["total"].present? && zone_result["careers"]["total"].to_i > 0
	                		@zone_results << zone_result
	              		end
	              	 end
              	end


	  		else

		  		@step_number = "Step 3 of 4"
		  		@header_desc = "Careers that fit your interests and preparation level (click below for details/select):"
		  		@zone_results = []
			  	onet_ws = OnetWebService.new("arwins","9436zfu")
				@job_zone_desc = onet_ws.get_interest_profiler_job_zones
			  	count = 1
			  	while count < 6
			  		zone_result = onet_ws.get_interest_profiler_matching_carrers(session[:INPUT_RESULT].to_i,count)
			  		@zone_results << zone_result
			  		count = count + 1
			  	end
			 end
  		when "interest_profiler_last"
  			@step_number = "Step 4 of 4"
  			@header_desc = ""
  			assessment_career = AssessmentCareer.get_assessment_career(session[:CLIENT_ID], session[:CLIENT_ASSESSMENT_ID])
	    	Rails.logger.debug("assessment_career = #{assessment_career.inspect}")
	    	career_detail = OnetWebService.new("arwins","9436zfu").get_interest_profiler_full_career_report(assessment_career.career_code)
	    	@career_detail_title = career_detail["report"]["career"]["title"]
	  	end

	  # 	if @client_assessment.interest_profiler_first_step?
	  # 		@questions = CodetableItem.item_list_id(203,"")
	  # 	elsif @client_assessment.interest_profiler_second_step?
	  # 		@zone_results = []
		 #  	onet_ws = OnetWebService.new("arwins","9436zfu")
			# @job_zone_desc = onet_ws.get_interest_profiler_job_zones
		 #  	count = 1
		 #  	while count < 6
		 #  		zone_result = onet_ws.get_interest_profiler_matching_carrers(session[:INPUT_RESULT].to_i,count)
		 #  		@zone_results << zone_result
		 #  		count = count + 1
		 #  	end
	  #   elsif @client_assessment.interest_profiler_last_step?
	  #   	assessment_career = AssessmentCareer.get_assessment_career(session[:CLIENT_ID], session[:CLIENT_ASSESSMENT_ID])
	  #   	Rails.logger.debug("assessment_career = #{assessment_career.inspect}")
	  #   	career_detail = OnetWebService.new("arwins","9436zfu").get_interest_profiler_full_career_report(assessment_career.career_code)
	  #   	@career_detail_title = career_detail["report"]["career"]["title"]
	  #   	# fail
	  # 	end


	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InterestProfilerQuestionsController","start_provider_agreement_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Attempted to access invalid Interest Profiler Questions"
		redirect_to interest_profiler_question_wizard_initialize_path
	end

  def process_interest_profiler_question_wizard
  		# fail
  		@client_assessment = ClientAssessment.new
      	@client_assessment.interest_profiler_current_step = params[:interest_profiler_current_step]
      	# Rails.logger.debug("-->params[:interest_profiler_current_step] = #{params[:interest_profiler_current_step]}")

      	if params[:back_button].present?
      		if session[:back] == "Education and Employment History" && !@client_assessment.interest_profiler_last_step?
      			@client_assessment.interest_profiler_previous_step
      		end
      		@client_assessment.interest_profiler_previous_step
      	elsif @client_assessment.interest_profiler_last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @client_assessment.interest_profiler_next_step
        end
        session[:INTEREST_PROFILER_QUESTION_STEP] = @client_assessment.interest_profiler_current_step

        # what step to process?
		if @client_assessment.interest_profiler_get_process_object == "interest_profiler_first" && params[:next_button].present?
			# fail
			if params[:answer].present?
				session[:back] = params[:answer]
				if params[:answer] == "Education and Employment History"
					onet_ws = OnetWebService.new("arwins","9436zfu")
					job_zones = onet_ws.get_interest_profiler_job_zones
					session[:INPUT_RESULT] = '113111311113112111131111113111331111111311311111111311311111'
					session[:INTEREST_PROFILER_QUESTION_STEP] = "interest_profiler_third"
					session[:back] = "Education and Employment History"
				else
					session[:INPUT_RESULT] = nil
				end
			else
				@client_assessment.interest_profiler_previous_step
				session[:INTEREST_PROFILER_QUESTION_STEP] = @client_assessment.interest_profiler_current_step
				flash[:notice] = "Please select atleast one option."
			end

			redirect_to start_interest_profiler_question_wizard_path
		elsif @client_assessment.interest_profiler_get_process_object == "interest_profiler_second" && params[:next_button].present?
			# session[:ZONE_RESULT] = nil
  			# session[:JOB_ZONES] = nil
			onet_ws = OnetWebService.new("arwins","9436zfu")
			job_zones = onet_ws.get_interest_profiler_job_zones
			# Rails.logger.debug("job_zones = #{job_zones.inspect}")
			# fail
						result = ""
						key = 6656
						while key < 6716
							result = result + params[key.to_s]
							key = key + 1
						end
						# Rails.logger.debug("-->result = #{result}")
						session[:INPUT_RESULT] = result
			# session[:INPUT_RESULT] = '113111311113112111131111113111331111111311311111111311311111'
			# zone1_result = onet_ws.get_interest_profiler_matching_carrers(result.to_i,1)
			# Rails.logger.debug("zone1_result = #{zone1_result.inspect}")
			# session[:ZONE_RESULT] = zone1_result
			# fail
			if result.size != 60
				@step_number = "Step 2 of 4"
		  		@header_desc = "Career Interest Profiler Questions"
		  		@questions = CodetableItem.item_list_id(203,"")
		  		@selected_dropdown_values = session[:INPUT_RESULT]
		  		@client_assessment.interest_profiler_previous_step
		  		flash.now[:notice] = "Please answer all the questions"
		  		render :start_interest_profiler_question_wizard
			else
				redirect_to start_interest_profiler_question_wizard_path
			end
		elsif @client_assessment.interest_profiler_get_process_object == "interest_profiler_third"
			# fail
			redirect_to start_interest_profiler_question_wizard_path
		elsif @client_assessment.interest_profiler_get_process_object == "interest_profiler_last"
			# fail
			redirect_to start_interest_profiler_question_wizard_path
		else
			redirect_to start_interest_profiler_question_wizard_path
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InterestProfilerQuestionsController","process_provider_agreement_wizard",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured when processing interest profiler questions"
		redirect_to_back
  end

  def career_details
  	@report_code = params[:report_code].to_s
  	@report_code = @report_code.insert(2,'-').insert(@report_code.length-2,'.')
  	# Rails.logger.debug("@report_code = #{@report_code}")
  	response = OnetWebService.new("arwins","9436zfu").get_interest_profiler_full_career_report(@report_code)
  	@career_details = response
  	# Rails.logger.debug("response = #{response.inspect}")
  	# fail
  	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InterestProfilerQuestionsController","career_details",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while retrieving career details information."
		redirect_to_back
  end

  def save_career_details
  	# Rails.logger.debug("session[:CLIENT_ASSESSMENT_ID] = #{session[:CLIENT_ASSESSMENT_ID]}")
  	# Rails.logger.debug("session[:CLIENT_ID] = #{session[:CLIENT_ID].inspect}")
  	assessment_career = AssessmentCareer.get_assessment_career(session[:CLIENT_ID], session[:CLIENT_ASSESSMENT_ID])
  	if assessment_career.blank?
  		assessment_career = AssessmentCareer.new
  		assessment_career.client_id = session[:CLIENT_ID]
  		assessment_career.assessment_id = session[:CLIENT_ASSESSMENT_ID]
  	end
  	report_code = params[:report_code].to_s
  	report_code = report_code.insert(2,'-').insert(report_code.length-2,'.')
  	assessment_career.career_code = report_code
  	if assessment_career.save
  		# Once Career Goal is saved, update the open action plan short term goal with the career code
  		action_plan = ActionPlan.get_open_action_plan_for_client(session[:CLIENT_ID])
  		if action_plan.present?
  			action_plan.short_term_goal = assessment_career.career_code
  			action_plan.save
  		end
  		session[:INTEREST_PROFILER_QUESTION_STEP] = "interest_profiler_last"
  	end
  	if session[:NAVIGATE_FROM].blank?
		redirect_to start_interest_profiler_question_wizard_path
	else
		navigate_back_to_called_page()
	end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("InterestProfilerQuestionsController","save_career_details",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occured while saving assessment career information."
		redirect_to_back
  end

	def navigate_to_second_step
  		session[:INTEREST_PROFILER_QUESTION_STEP] = "interest_profiler_third"
  		redirect_to start_interest_profiler_question_wizard_path
	end

	def clear_ipq_session_info
		session[:INPUT_RESULT] = nil
		session[:INTEREST_PROFILER_QUESTION_STEP] = nil
		redirect_to new_common_assessment_path(41,session[:CLIENT_ASSESSMENT_ID])
	end

end