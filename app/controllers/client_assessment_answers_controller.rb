class ClientAssessmentAnswersController < AttopAncestorController
	# Manoj Patil - 01/24/2014
	# common controller for all  assessment management.

	# common controller actions -start
	# 1.

	# 2.
	def new_common_assessment
		li_sub_section_id = params[:sub_section_id]
		if session[:CLIENT_ID].present?
			initialize_answer_object(li_sub_section_id)
			@common_assessment_answer_object = ClientAssessmentAnswer.new
			@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
			set_household_member_info_in_session(@client.id)
			set_current_step(li_sub_section_id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","new_common_assessment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred on new assessment."
		redirect_to_back
	end

	# 3.
	def create_common_assessment
		#  This happens only when Assessment is not created for client. -- first time.
		li_sub_section_id = params[:sub_section_id]
		initialize_answer_object(li_sub_section_id)
		qstn_answered = AssessmentService.any_question_answered?(params,@assessment_questions)
		if AssessmentQuestionMetadatum.is_date_valid(params)
			if qstn_answered == true
				ret_message = AssessmentService.save_assessment_answer(@assessment_id,params,@assessment_questions)
				if ret_message == "SUCCESS"
					program_unit_associated_with_assessment = ClientAssessment.get_program_unit_of_plan_for_this_assessment(@assessment_id)
					if program_unit_associated_with_assessment.present?
						if program_unit_associated_with_assessment.case_manager_id != current_user.uid
							# event to action mapping call to create task to case manager
							# step1 : Populate common event management argument structure
							common_action_argument_object = CommonEventManagementArgumentsStruct.new
							common_action_argument_object.event_id = 309 # Save Button
				             # for task
				            common_action_argument_object.program_unit_id = program_unit_associated_with_assessment.id
				            common_action_argument_object.client_id = session[:CLIENT_ID]
				            # step2: call common method to process event.
				            ls_msg = EventManagementService.process_event(common_action_argument_object)
						end
					end





					# flash[:notice] = "Assessment Data Saved successfully"
					if params[:next_button].present?
						if session[:NAVIGATE_FROM].blank?
			  				process_next_step()
				  		else
				  			navigate_back_to_called_page()
				  		end
					elsif params[:save_button].present?
						redirect_to edit_common_assessment_path(li_sub_section_id,@assessment_id)
					elsif params[:generate_assessment_button].present?
						redirect_to show_assessment_recommendations_path(@assessment_id)
					end

				else
					# save failed
					redirect_to new_common_assessment_path(li_sub_section_id,@assessment_id)
				end
			else
				if params[:next_button].present?
					if session[:NAVIGATE_FROM].blank?
		  				process_next_step()
			  		else
			  			navigate_back_to_called_page()
			  		end

				else
					# save button or generate_assessment_button is clicked.
					# Since this is the first time assessment ID is created for client and he has not answered any questions he can be redireted back to new common assessment path.
					redirect_to new_common_assessment_path(li_sub_section_id,@assessment_id)
				end
			end
		else
			# flash[:alert] = "Invalid Date"
			# redirect_to new_common_assessment_path(li_sub_section_id,@assessment_id)
			initialize_answer_object(li_sub_section_id)
			@common_assessment_answer_object = ClientAssessmentAnswer.new
			@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
			set_current_step(li_sub_section_id)
			@common_assessment_answer_object.errors[:base] = "Invalid date."
			render :new_common_assessment
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","create_common_assessment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when saving assessment."
		redirect_to_back
	end

	# 4.
	def edit_common_assessment
		if session[:CLIENT_ID].present?
			populate_assessement_in_session(session[:CLIENT_ID])
			session[:NAVIGATE_FROM] = nil unless request.env['HTTP_REFERER'].include?("assessment_recommendation")
			if assessment_plan_not_required
				populate_assessement_id_session(params[:sub_section_id])
				li_sub_section_id = params[:sub_section_id]
				initialize_answer_object(li_sub_section_id)
				@common_assessment_answer_object = ClientAssessmentAnswer.new
				@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
				set_household_member_info_in_session(@client.id)
				set_current_step(li_sub_section_id)
			else
				session[:NAVIGATE_FROM] = edit_common_assessment_path(params[:sub_section_id],params[:assessment_id])
				redirect_to assessment_activity_path
			end
		end

	rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","edit_common_assessment",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when editing assessment."
	 	redirect_to_back
	end



	# 5.
	def update_common_assessment
		li_sub_section_id = params[:sub_section_id]
		initialize_answer_object(li_sub_section_id)
		if AssessmentQuestionMetadatum.is_date_valid(params)

			ret_message = AssessmentService.save_assessment_answer(@assessment_id,params,@assessment_questions)
			if ret_message == "SUCCESS"
				# fail
				# if assessment is used in planning and the user other than case manager of the program unit in which this assessment's planning is used.
				# then create task to case manager - informing user: <> modified assessment for client, you may need to revisit his planning.
				program_unit_associated_with_assessment = ClientAssessment.get_program_unit_of_plan_for_this_assessment(@assessment_id)
				if program_unit_associated_with_assessment.present?
					if program_unit_associated_with_assessment.case_manager_id != current_user.uid
						# event to action mapping call to create task to case manager
						# step1 : Populate common event management argument structure
						common_action_argument_object = CommonEventManagementArgumentsStruct.new
						common_action_argument_object.event_id = 732 # Save Button
			             # for task
			            common_action_argument_object.program_unit_id = program_unit_associated_with_assessment.id
			            common_action_argument_object.client_id = session[:CLIENT_ID]
			            # step2: call common method to process event.
			            ls_msg = EventManagementService.process_event(common_action_argument_object)
					end
				end
				if params[:next_button].present?
					if session[:NAVIGATE_FROM].blank?
						process_next_step()
			  		else
			  			navigate_back_to_called_page()
			  		end
				elsif params[:save_button].present?

					redirect_to edit_common_assessment_path(li_sub_section_id,@assessment_id)
				elsif params[:generate_assessment_button].present?

					redirect_to show_assessment_recommendations_path(@assessment_id)
				end

			else

				 flash[:notice] = "Failed to save assessment data."
				 redirect_to edit_common_assessment_path(li_sub_section_id,@assessment_id)
			end

		else
			flash[:alert] = "Invalid data."
			redirect_to edit_common_assessment_path(li_sub_section_id,@assessment_id)
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","update_common_assessment",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when updating assessment."
		redirect_to_back
	end


	def process_previous_step
		@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
		@client_assessment.current_step = session["CURRENT_MENU_SELECTED"]
		determine_step_location = ClientAssessment.to_determine_previous_step_functionality(@client_assessment.current_step)
		if determine_step_location.blank?
			@client_assessment.previous_step
			ls_step = @client_assessment.current_step
			ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
			ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
			redirect_to("#{ls_step}")
		else
			if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].present?
				if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].include? determine_step_location.to_s
					if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].first == determine_step_location.to_s
						redirect_to selected_sections_for_short_assessment_path(session[:CLIENT_ID])
					else
						selected_sections = session[:SELECTED_SECTIONS_FOR_ASSESSMENT]
						previous_selected_section = selected_sections[selected_sections.index(determine_step_location.to_s) - 1]
						selected_step = ClientAssessment.get_previous_selected_step(previous_selected_section)
						@client_assessment.short_assessment_previous_step(selected_step)
						ls_step = @client_assessment.current_step
						ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
						ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
						redirect_to("#{ls_step}")
					end
				else
					# session[:SELECTED_SECTIONS_FOR_ASSESSMENT] = nil
					@client_assessment.previous_step
					ls_step = @client_assessment.current_step
					ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
					ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
					redirect_to("#{ls_step}")
				end
			else
				# session[:SELECTED_SECTIONS_FOR_ASSESSMENT] = nil
				@client_assessment.previous_step
				ls_step = @client_assessment.current_step
				ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
				ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
				redirect_to("#{ls_step}")
			end
		end
		rescue => err
			error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","process_previous_step",err,current_user.uid)
			flash[:alert] = "Error ID: #{error_object.id} - Error occurred when going to previous step in assessment."
			redirect_to_back
	end

	def process_next_step
		@client_assessment = ClientAssessment.find(session[:CLIENT_ASSESSMENT_ID].to_i)
		@client_assessment.current_step = session["CURRENT_MENU_SELECTED"]
		determine_step_location = ClientAssessment.to_determine_next_step_functionality(@client_assessment.current_step)
		if determine_step_location.blank?
			# fail
			@client_assessment.next_step
			ls_step = @client_assessment.current_step
			ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
			ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
			redirect_to("#{ls_step}")
		else
			if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].present?
				if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].include? determine_step_location.to_s
					if session[:SELECTED_SECTIONS_FOR_ASSESSMENT].last == determine_step_location.to_s
						redirect_to show_assessment_recommendations_path(session[:CLIENT_ASSESSMENT_ID])
					else
						selected_sections = session[:SELECTED_SECTIONS_FOR_ASSESSMENT]
						next_selected_section = selected_sections[selected_sections.index(determine_step_location.to_s) + 1]
						selected_step = ClientAssessment.get_next_selected_step(next_selected_section)
						@client_assessment.short_assessment_next_step(selected_step)
						ls_step = @client_assessment.current_step
						ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
						ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
						redirect_to("#{ls_step}")
					end
				else
					# session[:SELECTED_SECTIONS_FOR_ASSESSMENT] = nil
					@client_assessment.next_step
					ls_step = @client_assessment.current_step
					ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
					ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
					redirect_to("#{ls_step}")
				end
			else
				# session[:SELECTED_SECTIONS_FOR_ASSESSMENT] = nil
				@client_assessment.next_step
				ls_step = @client_assessment.current_step
				ls_assessment_id = session[:CLIENT_ASSESSMENT_ID]
				ls_step.gsub!('session[:CLIENT_ASSESSMENT_ID]', "#{ls_assessment_id}")
				redirect_to("#{ls_step}")
			end
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","process_next_step",err,current_user.uid)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when going to next step in assessment."
		redirect_to_back
	end

	private
		def initialize_answer_object(arg_sub_section_id)
			@sub_section_id = arg_sub_section_id
			@client = Client.find(session[:CLIENT_ID])
			@assessment_id = session[:CLIENT_ASSESSMENT_ID]
			@assessment_object = ClientAssessment.find(@assessment_id)
			@assessment_questions = AssessmentQuestion.get_questions_collection(arg_sub_section_id) # # EDucation -English Subscetion
		end


		def set_current_step(arg_menu)

			case arg_menu
				 when "14"
					 @client_assessment.current_step = "/14/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "12"
					@client_assessment.current_step = "/12/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "13"
					@client_assessment.current_step = "/13/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "2"
					@client_assessment.current_step = "/2/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "3"
					@client_assessment.current_step = "/3/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "6"
					@client_assessment.current_step = "/6/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "7"
					@client_assessment.current_step = "/7/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "8"
					@client_assessment.current_step = "/8/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "assessment_careers"
					@client_assessment.current_step = "/assessment_careers/interest_profiler_questions/interest_profiler_question_wizard_initialize"
				when "41"
					@client_assessment.current_step = "/41/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "42"
					@client_assessment.current_step = "/42/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
     			when "15"
					@client_assessment.current_step = "/15/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "29"
					@client_assessment.current_step = "/29/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "30"
					@client_assessment.current_step = "/30/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "35"
					@client_assessment.current_step = "/35/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "36"
					@client_assessment.current_step = "/36/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "32"
					@client_assessment.current_step = "/32/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "33"
					@client_assessment.current_step = "/33/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "38"
					@client_assessment.current_step = "/38/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "39"
					@client_assessment.current_step = "/39/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "19"
					@client_assessment.current_step = "/19/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "21"
					@client_assessment.current_step = "/21/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "22"
					@client_assessment.current_step = "/22/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "23"
					@client_assessment.current_step = "/23/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "24"
					@client_assessment.current_step = "/24/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "25"
					@client_assessment.current_step = "/25/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "26"
					@client_assessment.current_step = "/26/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "45"
					@client_assessment.current_step = "/45/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "46"
					@client_assessment.current_step = "/46/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"
				when "27"
					@client_assessment.current_step = "/27/assessment_edit/session[:CLIENT_ASSESSMENT_ID]/edit_common_assessment"

			end
			session["CURRENT_MENU_SELECTED"] = @client_assessment.current_step
			 # clients_age = Client.get_age(session[:CLIENT_ID])
    #             if clients_age != -1
	   #          	li_adult_age = SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
	   #            if clients_age < li_adult_age
		  #            flash.now[:alert]= "Assessment is required only for adults and minor parents, this client's age is #{clients_age}."
	   #            end
    #             end

		end


	def populate_assessement_id_session(arg_sub_section_id)
		li_sub_section_id = arg_sub_section_id
		@client = Client.find(session[:CLIENT_ID])
		@existing_client_assessment = ClientAssessment.get_client_assessments(@client.id)
		if @existing_client_assessment.present?
			@client_assessment = @existing_client_assessment.first
			session[:CLIENT_ASSESSMENT_ID] = @client_assessment.id
			initialize_answer_object(li_sub_section_id)
			assessment_answer_collection = ClientAssessmentAnswer.get_assessment_answers_collection(@assessment_id,li_sub_section_id) # EDucation -English Subscetion
			if assessment_answer_collection.blank?
				redirect_to new_common_assessment_path(li_sub_section_id,@assessment_id)
			end
		else
			@client_assessment = ClientAssessment.new
			@client_assessment.client_id = @client.id
			@client_assessment.assessment_date = Date.today
			@client_assessment.assessment_status = 6265
			if @client_assessment.save
				session["CLIENT_ASSESSMENT_ID"] = @client_assessment.id
				initialize_answer_object(li_sub_section_id)
				redirect_to new_common_assessment_path(li_sub_section_id,@assessment_id)
			end
		end
	 rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","populate_assessement_id_session",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when populating assessment."
	 	redirect_to_back
	end


	def populate_assessement_in_session(arg_client_id)
		@client = Client.find(session[:CLIENT_ID])
		@existing_client_assessment = ClientAssessment.get_client_assessments(@client.id)
		if @existing_client_assessment.present?
			@client_assessment = @existing_client_assessment.first
			session[:CLIENT_ASSESSMENT_ID] = @client_assessment.id
		else
			@client_assessment = ClientAssessment.new
			@client_assessment.client_id = @client.id
			@client_assessment.assessment_date = Date.today
			@client_assessment.assessment_status = 6265
			if @client_assessment.save
				session["CLIENT_ASSESSMENT_ID"] = @client_assessment.id
			end
		end
	rescue => err
	 	error_object = CommonUtil.write_to_attop_error_log_table("ClientAssessmentAnswersController","populate_assessement_id_session",err,current_user.uid)
	 	flash[:alert] = "Error ID: #{error_object.id} - Error occurred when populating assessment."
	 	redirect_to root_path
	end



end