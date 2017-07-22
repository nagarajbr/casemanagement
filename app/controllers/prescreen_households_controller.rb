 class PrescreenHouseholdsController < AttopAncestorController

	# Static Text to be displayed explaing Pre screening information to end user.
	def show
		# reset session[:CLIENT_ID] - because pre screening is done for new client & they target only staging prescreen tables.
		session[:CLIENT_ID] = nil
	end


	def cancel_wizard

		# delete all related records for householdID if they cancel halfway.
		@household_pre_screening = PrescreenHousehold.find(session[:HOUSEHOLD_PRE_SCREENING_ID].to_i)
		@household_pre_screening.destroy

		redirect_to show_pre_screening_household_path
	end

	def pre_screening_household_wizard_initialize
		session[:HOUSEHOLD_PRE_SCREENING_STEP] = session[:CLIENT_ID] = nil
		household_pre_screen_object = PrescreenHousehold.new
		household_pre_screen_object.processing_location = 6650 #centarl office
		if  household_pre_screen_object.save

			session[:HOUSEHOLD_PRE_SCREENING_ID] = household_pre_screen_object.id
			redirect_to start_pre_screening_household_wizard_path
		else

			flash[:notice] = "Failed to start pre screening process."
			redirect_to show_pre_screening_household_path
		end

	end

	def start_pre_screening_household_wizard
		# like new REST action
		# common instance variable for all steps


		if session[:HOUSEHOLD_PRE_SCREENING_STEP].blank?
      	 	session[:HOUSEHOLD_PRE_SCREENING_STEP] = nil
      	end


      	@household_pre_screening = PrescreenHousehold.find(session[:HOUSEHOLD_PRE_SCREENING_ID].to_i)


      	@household_pre_screening.current_step = session[:HOUSEHOLD_PRE_SCREENING_STEP]

      	if session[:HOUSEHOLD_PRE_SCREENING_STEP] == "prescreen_household_first" || @household_pre_screening.current_step == "prescreen_household_first"
      		@prescreen_household_members = @household_pre_screening.prescreen_household_members
      		if @prescreen_household_members.present?
      			populate_prescreen_household_virtual_fields_by_household_id(@household_pre_screening.id)
      		end
      	elsif  session[:HOUSEHOLD_PRE_SCREENING_STEP] == "prescreen_household_second"
      		@prescreen_household_members = @household_pre_screening.prescreen_household_members

      	elsif  session[:HOUSEHOLD_PRE_SCREENING_STEP] == "prescreen_household_third"

      	elsif  session[:HOUSEHOLD_PRE_SCREENING_STEP] == "prescreen_household_fourth"
      	elsif  session[:HOUSEHOLD_PRE_SCREENING_STEP] == "prescreen_household_fifth"

      		# create_prescreen_household_q_a_records(@household_pre_screening.id)
      		# @prescreen_household_question_answers = @household_pre_screening.prescreen_household_q_answers.order("id ASC")
      		# @prescreen_household_question_answers_y_n = PrescreenHouseholdQAnswer.get_answered_questions(@household_pre_screening.id)
      		li_sub_section_id = 47#2 #  working subsection
			@assessment_questions = AssessmentQuestion.get_questions_collection(li_sub_section_id) #
			@prescreen_household_id = @household_pre_screening.id
      		@prescreen_household_question_answers_y_n = PrescreenAssessmentAnswer.get_answers_collection_for_prescreen_household_id(@household_pre_screening.id)
      	elsif  session[:HOUSEHOLD_PRE_SCREENING_STEP] == "prescreen_household_last"
      		# CALL THE METHOD TO POPULATE DETERMINE RESULTS.

      		# PrescreenHouseholdQAnswer.determine_workforce_programs(@household_pre_screening.id)
      		determine_program_eligibility_rules(@household_pre_screening.id)
      		# @household_prescreen_results = @household_pre_screening.prescreen_household_results
      		@household_prescreen_results = PrescreenHouseholdResult.pre_screen_household_work_force_programs(@household_pre_screening.id)

      		@household_prescreen_results_supportive_services = PrescreenHouseholdResult.pre_screen_household_supportive_service_programs(@household_pre_screening.id)


      	end


	end



	def process_pre_screening_household_wizard

		# like create REST action
		# Multi step form create - wizard
		#  Rule1 - Processing takes place only when "NEXT" button is clicked.
		#  Rule2 - When "BACK" button is clicked just navigate to previous step - NO PROCESSING needed.
		# Instantiate client object

		# populate instance variables

      	@household_pre_screening = PrescreenHousehold.find(session[:HOUSEHOLD_PRE_SCREENING_ID].to_i)

      	@household_pre_screening.current_step = session[:HOUSEHOLD_PRE_SCREENING_STEP]

      	 # manage steps
      	if params[:back_button].present?
      		 @household_pre_screening.previous_step
      	elsif @household_pre_screening.last_step?
      		# reached final step - no changes to step - this is needed, so that we don't increment to next step
      	else
           @household_pre_screening.next_step
        end
       session[:HOUSEHOLD_PRE_SCREENING_STEP] = @household_pre_screening.current_step
         # what step to process?
		if @household_pre_screening.get_process_object == "prescreen_household_first" && params[:next_button].present?

			#1. Demographics

			# prescreening_household_member
			l_params = screen_household_member_params
			if @household_pre_screening.household_name.present?

			 	# update
			 	prescreen_household_member = PrescreenHouseholdMember.get_primary_household_member_object( @household_pre_screening.id)
				prescreen_household_member.primary_member_flag = "Y"
				prescreen_household_member.first_name = l_params[:first_name]
				prescreen_household_member.last_name = l_params[:last_name]
				prescreen_household_member.date_of_birth = l_params[:date_of_birth]
				prescreen_household_member.citizenship_flag = l_params[:citizenship_flag]
				prescreen_household_member.residency_flag = l_params[:residency_flag]
				prescreen_household_member.disabled_flag = l_params[:disabled_flag]
				prescreen_household_member.veteran_flag = l_params[:veteran_flag]
				prescreen_household_member.ssn = params[:ssn].scan(/\d/).join
				prescreen_household_member.pregnancy_flag = l_params[:pregnancy_flag]
				prescreen_household_member.zip_code = l_params[:zip]
				prescreen_household_member.highest_education_grade_completed = l_params[:highest_education_grade_completed]
				prescreen_household_member.attending_school = l_params[:attending_school]
				prescreen_household_member.caretaker_flag = l_params[:caretaker_flag]

				if prescreen_household_member.save

					# Save the Last Name as Household Name.
					@household_pre_screening.household_name = l_params[:last_name]
					@household_pre_screening.zip = l_params[:zip]
					@household_pre_screening.save
					session[:PRESCREEN_PRIMARY_MEMBER_NAME] = "#{prescreen_household_member.last_name}, #{prescreen_household_member.first_name}"
					redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
				else
					populate_prescreen_household_virtual_fields(l_params)
					@household_pre_screening.previous_step
					session[:HOUSEHOLD_PRE_SCREENING_STEP] = @household_pre_screening.current_step
					@error_object = prescreen_household_member
					render :start_pre_screening_household_wizard
				end
			else
				# new record.
				prescreen_household_member = @household_pre_screening.prescreen_household_members.new
				# set values
				prescreen_household_member.first_name = l_params[:first_name]
				prescreen_household_member.last_name = l_params[:last_name]
				prescreen_household_member.date_of_birth = l_params[:date_of_birth]
				prescreen_household_member.citizenship_flag = l_params[:citizenship_flag]
				prescreen_household_member.residency_flag = l_params[:residency_flag]
				prescreen_household_member.disabled_flag = l_params[:disabled_flag]
				prescreen_household_member.veteran_flag = l_params[:veteran_flag]
				prescreen_household_member.pregnancy_flag = l_params[:pregnancy_flag]
				prescreen_household_member.zip_code = l_params[:zip]
				prescreen_household_member.highest_education_grade_completed = l_params[:highest_education_grade_completed]
				prescreen_household_member.attending_school = l_params[:attending_school]
				prescreen_household_member.caretaker_flag = l_params[:caretaker_flag]
				prescreen_household_member.primary_member_flag = "Y"
				prescreen_household_member.ssn = params[:ssn].scan(/\d/).join
				# valid ?
				if prescreen_household_member.save
					# Save the Last Name as Household Name.
					@household_pre_screening.household_name = l_params[:last_name]
					@household_pre_screening.zip = l_params[:zip]
					@household_pre_screening.save
					session[:PRESCREEN_PRIMARY_MEMBER_NAME] = "#{prescreen_household_member.last_name}, #{prescreen_household_member.first_name}"
					redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
				else
					populate_prescreen_household_virtual_fields(l_params)
					@household_pre_screening.previous_step
					session[:HOUSEHOLD_PRE_SCREENING_STEP] = @household_pre_screening.current_step
					@error_object = prescreen_household_member
					# logger.debug("@error_object - inspect = #{@error_object.inspect}")
					render :start_pre_screening_household_wizard
				end
			end

		elsif @household_pre_screening.get_process_object == "prescreen_household_second" && params[:next_button].present?
			#2. Household Members & relationship to Self

			redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
		elsif @household_pre_screening.get_process_object == "prescreen_household_third" && params[:next_button].present?
			#3. Household Financials

			l_params = household_finacials_params
			# all fields are mandatory.
			lb_valid = false

			if l_params[:household_earned_income_amount].present?
				@household_pre_screening.household_earned_income_amount = l_params[:household_earned_income_amount]
				lb_valid = true
			else

				lb_valid = false
				@household_pre_screening.household_earned_income_amount = nil
				@household_pre_screening.errors[:base] << "Monthly earned income is required."

			end

			# 2.
			if l_params[:household_expense_amount].present?
				@household_pre_screening.household_expense_amount = l_params[:household_expense_amount]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.household_expense_amount = nil
				@household_pre_screening.errors[:base] << "Monthly household expenses is required."

			end

			# 3.
			if l_params[:household_resource_amount].present?
				@household_pre_screening.household_resource_amount = l_params[:household_resource_amount]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.household_resource_amount = nil
				@household_pre_screening.errors[:base] << "Monthly household resources is required."

			end

			if lb_valid == true
				@household_pre_screening.update(l_params)
				redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
			else
				 Rails.logger.debug("@household_pre_screening errors = #{@household_pre_screening.errors[:base].inspect}")
				@household_pre_screening.previous_step
				session[:HOUSEHOLD_PRE_SCREENING_STEP] = @household_pre_screening.current_step
				@error_object = @household_pre_screening
				Rails.logger.debug("@error_object - inspect = #{@error_object.inspect}")
				render :start_pre_screening_household_wizard
			end



		elsif @household_pre_screening.get_process_object == "prescreen_household_fourth" && params[:next_button].present?
			# 4.  Household benefits
			# all fields are mandatory.
			lb_valid = false
			l_params = household_benefits_params
			if l_params[:household_unearned_income_amount].present?
				@household_pre_screening.household_unearned_income_amount = l_params[:household_unearned_income_amount]
				lb_valid = true
			else
				lb_valid = false
				@household_pre_screening.household_unearned_income_amount = nil
				@household_pre_screening.errors[:base] << "Monthly unearned income is required."
			end

			# 2.
			if l_params[:snap_benefit_amount].present?
				@household_pre_screening.snap_benefit_amount = l_params[:snap_benefit_amount]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.snap_benefit_amount = nil
				@household_pre_screening.errors[:base] << "Monthly SNAP benefits is required."

			end

			# 3.
			if l_params[:ssi_benefit_amount].present?
				@household_pre_screening.ssi_benefit_amount = l_params[:ssi_benefit_amount]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.ssi_benefit_amount = nil
				@household_pre_screening.errors[:base] << "Monthly SSI benefits is required."

			end

			# 4.
			if l_params[:tanf_benefit_amount].present?
				@household_pre_screening.tanf_benefit_amount = l_params[:tanf_benefit_amount]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.tanf_benefit_amount = nil
				@household_pre_screening.errors[:base] << "Monthly TEA / work pays benefits is required."

			end
			# 5.
			if l_params[:ui_benefit_amount].present?
				@household_pre_screening.ui_benefit_amount = l_params[:ui_benefit_amount]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.ui_benefit_amount = nil
				@household_pre_screening.errors[:base] << "Monthly UI benefits is required."

			end

			# 6.
			if l_params[:receiving_medicaid_flag].present?
				@household_pre_screening.receiving_medicaid_flag = l_params[:receiving_medicaid_flag]
				if lb_valid == true
					lb_valid = true
				end
			else
				lb_valid = false
				@household_pre_screening.receiving_medicaid_flag = nil
				@household_pre_screening.errors[:base] << "Currently receiving medicaid is required."

			end

			if lb_valid == true

				@household_pre_screening.update(l_params)
				redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
			else
				Rails.logger.debug("@household_pre_screening errors = #{@household_pre_screening.errors[:base].inspect}")
				@household_pre_screening.previous_step
				session[:HOUSEHOLD_PRE_SCREENING_STEP] = @household_pre_screening.current_step
				@error_object = @household_pre_screening
				Rails.logger.debug("@error_object - inspect = #{@error_object.inspect}")
				render :start_pre_screening_household_wizard
			end



		elsif @household_pre_screening.get_process_object == "prescreen_household_fifth" && params[:next_button].present?
			# 5.  Household Q & A
			if PrescreenAssessmentAnswer.where("prescreen_household_id = ?",@household_pre_screening.id).count > 0
				redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
			else
				@household_pre_screening.errors[:base] << "PreScreen Assessment is required"
				Rails.logger.debug("@household_pre_screening errors = #{@household_pre_screening.errors[:base].inspect}")
				@household_pre_screening.previous_step
				session[:HOUSEHOLD_PRE_SCREENING_STEP] = @household_pre_screening.current_step
				@error_object = @household_pre_screening
				Rails.logger.debug("@error_object - inspect = #{@error_object.inspect}")
				render :start_pre_screening_household_wizard
			end



		elsif @household_pre_screening.current_step == "prescreen_household_last"
			# 6. Prescreening Results & contact details
			l_params = household_contact_params
			l_params[:phone] = l_params[:phone].scan(/\d/).join
			@household_pre_screening.update(l_params)
			redirect_to prescreen_household_thankyou_path(@household_pre_screening.id)
			# redirect_to edit_prescreen_capture_ssn_path(@household_pre_screening.id)


		else
			# previous button is clicked.
			redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
		end


	end

	def prescreen_household_thankyou
			@household_pre_screening = PrescreenHousehold.find(params[:household_prescreening_id].to_i)
			primary_member_object = PrescreenHouseholdMember.get_primary_household_member_object(@household_pre_screening.id)
			@primary_member = "#{primary_member_object.last_name}, #{primary_member_object.first_name}"
			# reset all session variables
			  # session[:HOUSEHOLD_PRE_SCREENING_ID] = session[:HOUSEHOLD_PRE_SCREENING_STEP] = session[:PRESCREEN_PRIMARY_MEMBER_NAME] = nil
	end

	# def update_prescreen_household_thankyou

	# 	@household_pre_screening = PrescreenHousehold.find(params[:household_prescreening_id].to_i)
	# 	l_params = household_thankyou_params
	# 	if l_params[:save_prescreen_data_flag] == "N"

	# 		@household_pre_screening.destroy
	# 		redirect_to show_pre_screening_household_path
	# 	else
	# 		redirect_to client_applications_path
	# 	end


	# end


	#  Add Household member functionality start
	def new_prescreen_household_member
		@household_pre_screening = PrescreenHousehold.find(params[:prescreen_household_id].to_i)
		session[:NAVIGATED_FROM] = start_pre_screening_household_wizard_path(@household_pre_screening.id)
		@prescreen_household_member = PrescreenHouseholdMember.new
	end

	def create_prescreen_household_member

		@household_pre_screening = PrescreenHousehold.find(params[:prescreen_household_id].to_i)
		l_params = new_household_member_params
		# # Remove relationship from
		# if l_params[:relationship_with_primary_member].present?
		# 	l_relationship_type = l_params[:relationship_with_primary_member]
		# 	l_params = l_params.reject!{ |k| k == :relationship_with_primary_member }
		# else
		# 	l_params = new_household_member_params
		# end

		l_params = new_household_member_params
		@prescreen_household_member = @household_pre_screening.prescreen_household_members.new(l_params)

		# Temp setting - since this virtual field is mandatory - start
		@prescreen_household_member.zip_code = 111
		# Temp setting - since this virtual field is mandatory - start

		@prescreen_household_member.primary_member_flag = "N"
		@prescreen_household_member.ssn = params[:ssn].scan(/\d/).join
		if @prescreen_household_member.valid?

			if l_params[:relation_to_primary_member].present?

				@prescreen_household_member.save
				flash[:notice] = "Household member added successfully."
				redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
			else

				@prescreen_household_member.errors[:base] << "Relationship to primary member is required."
				render :new_prescreen_household_member
			end
		else

			if l_params[:relation_to_primary_member].blank?
				@prescreen_household_member.errors[:base] << "Relationship to primary member is required."
			end
			render :new_prescreen_household_member
		end

		# if @prescreen_household_member.save
		# 	flash[:notice] = "Household Member added successfully."
		# 	redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
		# else
		# 	render :new_prescreen_household_member
		# end
	end

	def destroy_prescreen_household_member
		@household_pre_screening = PrescreenHousehold.find(params[:prescreen_household_id].to_i)
		prescreen_household_member = PrescreenHouseholdMember.find(params[:id])
		prescreen_household_member.destroy
		flash[:alert] = "Household member deleted successfully."
		redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
	end
	#  Add Household member functionality end

# Manage Answers calls this Action




	def edit_prescreen_common_assessment
		li_sub_section_id = 47#2 #  working subsection
		@assessment_questions = AssessmentQuestion.get_questions_collection(li_sub_section_id) #
		@prescreen_household_id = params[:household_prescreening_id]
		@common_prescreen_assessment_answer_object = PrescreenAssessmentAnswer.new
	end

	def update_prescreen_common_assessment
		li_sub_section_id = 47#2 #  working subsection
		@assessment_questions = AssessmentQuestion.get_questions_collection(li_sub_section_id) #
		@prescreen_household_id = params[:household_prescreening_id]
		if AssessmentQuestionMetadatum.is_date_valid(params)
			ret_message = AssessmentService.save_prescreen_assessment_answer(@prescreen_household_id,params,@assessment_questions)
			if ret_message == "SUCCESS"
				# flash[:notice] = "Assessment Data Saved successfully"
				redirect_to start_pre_screening_household_wizard_path(@prescreen_household_id)
			else
				flash[:alert] = "Failed to save assessment data."
				redirect_to edit_prescreen_common_assessment_path(@prescreen_household_id)
			end
		else
			flash[:alert] = "Invalid data."
			redirect_to edit_prescreen_common_assessment_path(@prescreen_household_id)
		end

	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("PrescreenHouseholdsController","update_prescreen_common_assessment",err,current_user.id)
		flash[:alert] = "Error ID: #{error_object.id} - Error occurred when updating prescreen assessment."
		redirect_to edit_prescreen_common_assessment_path(@prescreen_household_id)
	end
	# def edit_prescreen_household_question_answers

	# 	@household_pre_screening = PrescreenHousehold.find(params[:household_prescreening_id].to_i)
	# 	@prescreen_household_question_answers = @household_pre_screening.prescreen_household_q_answers.order("id ASC")
	# 	session[:NAVIGATED_FROM] = start_pre_screening_household_wizard_path(@household_pre_screening.id)
	# end

	# Put action of  Manage Relationship .
	# def update_prescreen_household_question_answers

	# 	{"utf8"=>"✓",
 # "_method"=>"put",
 # "authenticity_token"=>"oc77r3TGySyn8V1btWkZiWS6wohyhza0QOvqtDvLwVw=",
 # "prescreen_hh_q_answers"=>{"9"=>{"answer_flag"=>"Y",
 # "id"=>"9",
 # "question_id"=>"6061"},
 # "10"=>{"answer_flag"=>"Y",
 # "id"=>"10",
 # "question_id"=>"6062"},
 # "11"=>{"id"=>"11",
 # "question_id"=>"6063"},
 # "12"=>{"id"=>"12",
 # "question_id"=>"6064"},
 # "13"=>{"id"=>"13",
 # "question_id"=>"6065"},
 # "14"=>{"id"=>"14",
 # "question_id"=>"6066"},
 # "15"=>{"id"=>"15",
 # "question_id"=>"6067"},
 # "16"=>{"id"=>"16",
 # "question_id"=>"6068"}},
 # "commit"=>"Save",
 # "household_prescreening_id"=>"19"}
	# 	l_params_collection = params[:prescreen_hh_q_answers]
	# 	@household_pre_screening = PrescreenHousehold.find(params[:household_prescreening_id].to_i)

	# 	l_params_collection.each do |arg_q_a_hash|
	# 		l_hash = arg_q_a_hash[1] # will have {"answer_flag"=>"Y", "id"=>"9", "question_id"=>"6061"}
	# 		q_a_object = PrescreenHouseholdQAnswer.find(l_hash[:id])
	# 		q_a_object.question_id = l_hash[:question_id]
	# 		q_a_object.answer_flag = l_hash[:answer_flag]
	# 		q_a_object.save
	# 	end
	# 	redirect_to start_pre_screening_household_wizard_path(@household_pre_screening.id)
	# end


	# Capture SSN after user clicks on Apply for selected programs

	def edit_prescreen_capture_ssn
			@household_pre_screening = PrescreenHousehold.find(params[:household_prescreening_id].to_i)
			@prescreen_household_member = PrescreenHouseholdMember.get_primary_household_member_object(@household_pre_screening.id)
			@primary_member = "#{@prescreen_household_member.last_name}, #{@prescreen_household_member.first_name}"
			pra_text_for_pre_screening = SystemParam.get_pra_text_for_pre_screening()
			@prescreen_household_member.personal_responsibility_agreement = pra_text_for_pre_screening
			@prescreen_household_member.pra_accept = 0
	end

	def update_prescreen_capture_ssn
		@household_pre_screening = PrescreenHousehold.find(params[:household_prescreening_id].to_i)
		@prescreen_household_member = PrescreenHouseholdMember.get_primary_household_member_object(@household_pre_screening.id)
		@primary_member = "#{@prescreen_household_member.last_name}, #{@prescreen_household_member.first_name}"

		l_params = capture_ssn_params
		#  update household member
		@prescreen_household_member.first_name =  l_params[:first_name]
		@prescreen_household_member.last_name = l_params[:last_name]
		@prescreen_household_member.ssn = l_params[:ssn].scan(/\d/).join
		@prescreen_household_member.date_of_birth = l_params[:date_of_birth]
		@prescreen_household_member.personal_responsibility_agreement = l_params[:personal_responsibility_agreement]
		@prescreen_household_member.pra_accept = l_params[:pra_accept]
			# Temp setting - since this virtual field is mandatory - start
		@prescreen_household_member.zip_code = 111
		# Temp setting - since this virtual field is mandatory - start

		begin
			ActiveRecord::Base.transaction do
				if @prescreen_household_member.valid?
					@prescreen_household_member.save!

					@household_pre_screening.household_name = l_params[:last_name]
					@household_pre_screening.save!

					# Add record to Intake Queue.
					l_potential_intake_client_object = PotentialIntakeClient.new
					l_potential_intake_client_object.first_name =  @prescreen_household_member.first_name
					l_potential_intake_client_object.last_name = @prescreen_household_member.last_name
					l_potential_intake_client_object.ssn =  @prescreen_household_member.ssn
					l_potential_intake_client_object.date_of_birth =  @prescreen_household_member.date_of_birth
					l_potential_intake_client_object.prescreen_household_id = @household_pre_screening.id
					l_potential_intake_client_object.save!

					#Add household record
					@household_object = Household.new
					@household_object.name = @household_pre_screening.household_name
					@household_object.processing_location_id = 18 #little rock workforce center
					@household_object.save!

					prescreenhousehold_members = PrescreenHouseholdMember.where("prescreen_household_id = ?",@household_pre_screening.id).order("primary_member_flag desc")

					prescreenhousehold_members.each do |pshm|
						#Add client
						@client = Client.new
						@client.first_name = pshm.first_name
						@client.last_name = pshm.last_name
						if pshm.ssn.present?
							@client.ssn = pshm.ssn
						else
							psuedo_ssn = ActiveRecord::Base.connection.select_value("SELECT nextval('ssn_seq')")
							@client.ssn = psuedo_ssn
						end
						@client.dob = pshm.date_of_birth
						@client.save!

						#Add Householdmembers
						household_member = HouseholdMember.new
						household_member.household_id = @household_object.id
						household_member.client_id = @client.id
						household_member.head_of_household_flag = pshm.primary_member_flag
						household_member.member_status = 6643
						household_member.save!
					end


					# Add to prescreenig queue
					common_action_argument_object = CommonEventManagementArgumentsStruct.new
					common_action_argument_object.event_id = 846 # Initiate application process Button
		            common_action_argument_object.queue_reference_type = 6718 # Pre-screening process
		            common_action_argument_object.queue_reference_id = @household_object.id
		            common_action_argument_object.queue_worker_id = AuditModule.get_current_user.uid
		            # step2: call common method to process event.
		            ls_msg = EventManagementService.process_event(common_action_argument_object)
		            session[:HOUSE_HOLD_REGISTRATION_COMPLETE] = 'N'
					# redirect_to prescreen_household_thankyou_path(@household_pre_screening.id)
					render 'thank_you_initiate_application'

				else
					render :edit_prescreen_capture_ssn
				end

			end
			rescue => err
	          error_object = CommonUtil.write_to_attop_error_log_table("PrescreenHouseholdsController","update_prescreen_capture_ssn",err,AuditModule.get_current_user.uid)
	          msg = "Failed to apply for intake - for more details refer to error ID: #{error_object.id}."
	          redirect_to_back
		end
	end

	def populate_details_from_xml
		@licence_id = params[:licence_id]
		@household_pre_screening = PrescreenHousehold.find(session[:HOUSEHOLD_PRE_SCREENING_ID].to_i)
		result_hash = XmlReaderService.read_xml
		# Rails.logger.debug("@household_pre_screening = #{@household_pre_screening.inspect}")
		# Rails.logger.debug("result_hash = #{result_hash.inspect}")
		@household_pre_screening.last_name = result_hash["client"]["last_name"]
		@household_pre_screening.first_name = result_hash["client"]["first_name"]
		@household_pre_screening.date_of_birth = result_hash["client"]["dob"].to_date
		@ssn = result_hash["client"]["ssn"]
		@household_pre_screening.zip = result_hash["client"]["zip"]
		render :start_pre_screening_household_wizard
	end





	private

	 def screen_household_member_params
		params.require(:prescreen_household).permit(:first_name, :last_name,:date_of_birth,:citizenship_flag,:residency_flag,:highest_education_grade_completed,:zip,:disabled_flag,:veteran_flag,:pregnancy_flag,:attending_school,:caretaker_flag)
  	 end

  	 def new_household_member_params
		params.require(:prescreen_household_member).permit(:first_name, :last_name,:date_of_birth,:citizenship_flag,:residency_flag,:highest_education_grade_completed,:relation_to_primary_member,:pregnancy_flag,:disabled_flag,:veteran_flag,:attending_school,:caretaker_flag)
  	 end

  	 def household_finacials_params
  	 	params.require(:prescreen_household).permit(:household_earned_income_amount, :household_expense_amount,:household_resource_amount)
  	 end

  	  def household_benefits_params
  	 	params.require(:prescreen_household).permit(:household_unearned_income_amount,:snap_benefit_amount,:ssi_benefit_amount,
  	 		                                       :tanf_benefit_amount,:ui_benefit_amount,:receiving_medicaid_flag
  	 		                                        )
  	 end

  	 def household_contact_params
  	 	params.require(:prescreen_household).permit(:phone, :email_address,:address_line1,:address_line2,:city,:state,:zip)
  	 end

  	 # def household_thankyou_params
  	 # 	params.require(:prescreen_household).permit(:save_prescreen_data_flag)
  	 # end

  	 def capture_ssn_params
  	 	params.require(:prescreen_household_member).permit(:first_name, :last_name,:date_of_birth,:middle_name,:suffix,:ssn,:gender,:marital_status,:identification_type,:primary_language,:personal_responsibility_agreement,:pra_accept)
  	 end





  	 def populate_prescreen_household_virtual_fields(arg_params)
  	 	@household_pre_screening.first_name = arg_params[:first_name]
  	 	@household_pre_screening.last_name = arg_params[:last_name]
  	 	@household_pre_screening.date_of_birth = arg_params[:date_of_birth]
  	 	if arg_params[:citizenship_flag].present?
  	 		@household_pre_screening.citizenship_flag = arg_params[:citizenship_flag]
  	 	end
  	 	if arg_params[:residency_flag].present?
  	 		@household_pre_screening.residency_flag = arg_params[:residency_flag]
  	 	end
  	 	if arg_params[:disabled_flag].present?
  	 		@household_pre_screening.disabled_flag = arg_params[:disabled_flag]
  	 	end
  	 	if arg_params[:veteran_flag].present?
  	 		@household_pre_screening.veteran_flag = arg_params[:veteran_flag]
  	 	end
  	 	if arg_params[:pregnancy_flag].present?
  	 		@household_pre_screening.pregnancy_flag = arg_params[:pregnancy_flag]
  	 	end
  	 	if arg_params[:attending_school].present?
  	 		@household_pre_screening.attending_school = arg_params[:attending_school]
  	 	end
  	 	if arg_params[:caretaker_flag].present?
  	 		@household_pre_screening.caretaker_flag = arg_params[:caretaker_flag]
  	 	end

  	 	@household_pre_screening.highest_education_grade_completed = arg_params[:highest_education_grade_completed]

  	 end

  	 def populate_prescreen_household_virtual_fields_by_household_id(arg_prescreen_household_id)
  	 	prescreen_household_member = PrescreenHouseholdMember.get_primary_household_member_object( arg_prescreen_household_id)
  	 	@household_pre_screening.first_name = prescreen_household_member.first_name
  	 	@household_pre_screening.last_name = prescreen_household_member.last_name
  	 	@household_pre_screening.date_of_birth = prescreen_household_member.date_of_birth
  	 	@household_pre_screening.citizenship_flag = prescreen_household_member.citizenship_flag
  	 	@household_pre_screening.residency_flag = prescreen_household_member.residency_flag
  	 	@household_pre_screening.disabled_flag = prescreen_household_member.disabled_flag
  	 	@household_pre_screening.veteran_flag = prescreen_household_member.veteran_flag
  	 	@household_pre_screening.highest_education_grade_completed =prescreen_household_member.highest_education_grade_completed

  	 	@household_pre_screening.pregnancy_flag =prescreen_household_member.pregnancy_flag
  	 	@household_pre_screening.attending_school =prescreen_household_member.attending_school
  	 	@household_pre_screening.caretaker_flag =prescreen_household_member.caretaker_flag

  	 end


  	 # def create_prescreen_household_q_a_records(arg_prescreen_household_id)
  	 # 	# check if any QA present in the household?
  	 # 	#  ALl household questions
  	 # 	household_pre_screening = PrescreenHousehold.find(arg_prescreen_household_id)
  	 # 	all_household_prescreening_questions = CodetableItem.get_prescreen_household_questions()
  	 # 	prescreen_household_q_answers = household_pre_screening.prescreen_household_q_answers
  	 # 	if prescreen_household_q_answers.blank?
  	 # 		all_household_prescreening_questions.each do |arg_q_a|
  	 # 			prescreen_household_q_answer_object = household_pre_screening.prescreen_household_q_answers.new
				# prescreen_household_q_answer_object.question_id = arg_q_a.id
				# prescreen_household_q_answer_object.question_category_id = CodetableItem.find(arg_q_a.id).code_table_id
				# prescreen_household_q_answer_object.save
  	 # 		end
  	 # 	end

  	 # end

# ***************************************************************************





	def get_only_adults_between_17_and_50(arg_prescreen_household_id)
    	if PrescreenHouseholdMember.where("( EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) between 17 and 50)
    	                                   and prescreen_household_id = ?",arg_prescreen_household_id).count > 0
    		return 'Y'
    		# ADULTS BETWEEN 17 & 50 ARE FOUND
    	else
    		return 'N'
    	end
    end

    def get_kids(arg_prescreen_household_id)
        	if PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) < 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count > 0
        		return 'Y'
        		# YES KIDS ARE FOUND
        	else
        		# NO KIDS ARE FOUND
        		return 'N'
        	end
    end

    def get_pregnant(arg_prescreen_household_id)
        	#  adult count
        	li_adult_count = PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count
        	# are all adults pregnant?
        	house_hold_members = PrescreenHouseholdMember.where("prescreen_household_id = ?",arg_prescreen_household_id)
        	li_pregnancy_count = 0
        	house_hold_members.each do |each_member|
        		if PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18 and id = ?",each_member.id)
        			if each_member.pregnancy_flag == 'Y'
        				li_pregnancy_count = li_pregnancy_count + 1
        			end
				end
        	end
        	if li_adult_count == li_pregnancy_count
        		return 'Y'
        		# YES ALL ADULTS ARE PREGNANT
        	else
        		return 'N'
        		# NOT ALL ADULTS ARE PREGNANT
        	end
    end

    def get_disbaled(arg_prescreen_household_id)
        	# YES - ALL ADULTS ARE DISABLED
        	# NO - NOT ALL ADULTS ARE DISABLED
        	#  adult count
        	li_adult_count = PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count
        	# are all adults pregnant?
        	house_hold_members = PrescreenHouseholdMember.where("prescreen_household_id = ?",arg_prescreen_household_id)
        	li_disabled_count = 0
        	house_hold_members.each do |each_member|
        		if PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18 and id = ?",each_member.id)
        			if each_member.disabled_flag == 'Y'
        				li_disabled_count = li_disabled_count + 1
        			end
				end
        	end
        	if li_adult_count == li_disabled_count
        		return 'Y'
        		# YES ALL ADULTS ARE DISABLED
        	else
        		return 'N'
        		# NOT ALL ADULTS ARE DISABLED
    		end
    end

    def get_veteran(arg_prescreen_household_id)
        	# YES - ALL ADULTS ARE DISABLED
        	# NO - NOT ALL ADULTS ARE DISABLED
        	#  adult count
        	li_adult_count = PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count
        	# are all adults pregnant?
        	house_hold_members = PrescreenHouseholdMember.where("prescreen_household_id = ?",arg_prescreen_household_id)
        	li_veteran_count = 0
        	house_hold_members.each do |each_member|
        		if PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18 and id = ?",each_member.id)
        			if each_member.veteran_flag == 'Y'
        				li_veteran_count = li_veteran_count + 1
        			end
				end
        	end
        	if li_adult_count == li_veteran_count
        		return 'Y'
        		# YES ALL ADULTS ARE VETERANS
        	else
        		return 'N'
        		# NOT ALL ADULTS ARE VETERAN
    		end

    end





    def get_attending_school(arg_prescreen_household_id)
        	# YES = ALL ADULTS ARE attending school
        	# NO - NOT ALL ADULTS ARE ARE attending school
        	li_adult_count = PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count
        	# are all adults pregnant?
        	house_hold_members = PrescreenHouseholdMember.where("prescreen_household_id = ?",arg_prescreen_household_id)
        	li_school_count = 0
        	house_hold_members.each do |each_member|
        		if PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18 and id = ?",each_member.id)
        			if each_member.attending_school != 6641 #"None"
        				li_school_count = li_school_count + 1
        			end
				end
        	end
        	if li_adult_count == li_school_count
        		return 'Y'
        		# YES ALL ADULTS ARE HIGH SCHOOL GRADUATE
        	else
        		return 'N'
        		# NOT ALL ADULTS ARE HIGH SCHOOL GRADUATE
        	end

    end

    def get_receiving_UI_or_TEA(arg_prescreen_household_id)
        	if PrescreenHousehold.where("(prescreen_households.ui_benefit_amount > 0 OR
        		                           prescreen_households.tanf_benefit_amount > 0 )
        		                           and id = ?",arg_prescreen_household_id).count > 0
        		return  'Y'
        		# YES HOUSEHOLD IS GETTING TEA OR UR
        	else
        		return  'N'
        		# YES HOUSEHOLD IS GETTING TEA OR UR
        	end
    end

        def get_family_size(arg_prescreen_household_id)
        	PrescreenHouseholdMember.where("prescreen_household_id = ?",arg_prescreen_household_id).count
        end

        def get_monthly_gross_income(arg_prescreen_household_id)
        	household = PrescreenHousehold.where("id = ?",arg_prescreen_household_id).first
        	return household.household_earned_income_amount
        end

         def get_are_you_currently_working(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 890
        		                                  and answer_value = 'Y'",arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES WORKING
        	else
        		return 'N'
        		# NOT WORKING

        	end
        end

        def get_health_insurance(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 905
        		                                  and answer_value = 'Y'",arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES JOB PROVIDES HEALTH INSURANCE
        	else
        		return 'N'
        		# NOT JOB DOES NOT PROVIDES HEALTH INSURANCE

        	end

        end

        def get_are_you_self_sufficient(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 906
        		                                  and answer_value = 'Y'",arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES self_sufficient
        	else
        		return 'N'
        		# NOT self_sufficient

        	end
        end


        def get_monthly_resource(arg_prescreen_household_id)
        	household = PrescreenHousehold.where("id = ?",arg_prescreen_household_id).first
        	return household.household_resource_amount
        end


        # "Laid off due to company downsizing or poor job performance"
        def laid_off_reason_found(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 892
        		                                  and answer_value = 'Laid off due to company downsizing or poor company performance'",
        		                                  arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES self_sufficient
        	else
        		return 'N'
        		# NOT self_sufficient

        	end
        end

        # "Jobs were outsourced"
        def jobs_outsourced_reason_found(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 893
        		                                  and answer_value = 'Jobs were outsourced'",
        		                                  arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES self_sufficient
        	else
        		return 'N'
        		# NOT self_sufficient

        	end
        end

# "Company closure"
        def company_closure_reason_found(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 893
        		                                  and answer_value = 'Company closure'",
        		                                  arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES self_sufficient
        	else
        		return 'N'
        		# NOT self_sufficient

        	end
        end

        # "on"
        def unemployed_more_than_year_reason_found(arg_prescreen_household_id)
        	if PrescreenAssessmentAnswer.where("prescreen_household_id = ?
        		                                  and assessment_question_id = 902
        		                                  and answer_value = 'on'",
        		                                  arg_prescreen_household_id ).count > 0
        		return 'Y'
        		# YES self_sufficient
        	else
        		return 'N'
        		# NOT self_sufficient

        	end
        end


        def get_non_caretaker(arg_prescreen_household_id)
        	# YES = ALL ADULTS ARE attending school
        	# NO - NOT ALL ADULTS ARE ARE attending school
        	lb_return = false
         	house_hold_members = PrescreenHouseholdMember.where("prescreen_household_id = ?",arg_prescreen_household_id)

        	house_hold_members.each do |each_member|
        		if PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18 and id = ?",each_member.id)
        			if each_member.caretaker_flag == 'N'
						lb_return = true
						break
        			end
				end
        	end

        	return lb_return

    	end


def determine_program_eligibility_rules(arg_prescreen_household_id)
  		# Food with E&T
  		only_adults_between_17_and_50 = get_only_adults_between_17_and_50(arg_prescreen_household_id)
  		kids_found = get_kids(arg_prescreen_household_id)
  		pregnancy_found = get_pregnant(arg_prescreen_household_id)
  		disbality_found = get_disbaled(arg_prescreen_household_id)

  		attending_school = get_attending_school(arg_prescreen_household_id)
  		receiving_UI_or_TEA = get_receiving_UI_or_TEA(arg_prescreen_household_id)
  		li_family_size = get_family_size(arg_prescreen_household_id)
  		ld_monthly_gross_income = get_monthly_gross_income(arg_prescreen_household_id)
  		non_caretaker_present = get_non_caretaker(arg_prescreen_household_id)

  		income_eligible_snap_result = income_eligible_SNAP(li_family_size,ld_monthly_gross_income)
  		# ******************************"SNAP E&T"************************************start***************

  		logger.debug("only_adults_between_17_and_50#{only_adults_between_17_and_50}")
  		logger.debug("kids_found#{kids_found}")
  		logger.debug("pregnancy_found#{pregnancy_found}")
  		logger.debug("disbality_found#{disbality_found}")
  		logger.debug("attending_school#{attending_school}")
  		logger.debug("receiving_UI_or_TEA#{receiving_UI_or_TEA}")
  		logger.debug("income_eligible_snap_result#{income_eligible_snap_result}")


  		if (only_adults_between_17_and_50 =='Y'	&& kids_found == 'N' && pregnancy_found == 'N' && disbality_found == 'N' && attending_school == 'N' && receiving_UI_or_TEA == 'N' && income_eligible_snap_result == true)

           		# insert into results table.
           		# programs_list[1] ="SNAP E&T"
           		result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 24 #"Food with E&T (SNAP)"
				result_object.save
        else
        	# SNAP RULES
        	if income_eligible_snap_result == true
               # programs_list[1] ="SNAP E&T"
               result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 17 #"SNAP"
				result_object.save


				if non_caretaker_present = true && attending_school == 'N'
                    result_object = PrescreenHouseholdResult.new
                    result_object.prescreen_household_id = arg_prescreen_household_id
                    result_object.service_program_category_id = 24 #"Food with E&T (SNAP)"
                    result_object.save
                end

            end

        end
        # ******************************"SNAP E&T"************************************end***************

        # ******************************"HCIP" Rules************************************start***************
        is_currently_working = get_are_you_currently_working(arg_prescreen_household_id)
        health_insurance = get_health_insurance(arg_prescreen_household_id)

        income_eligible_HCIP_eligible = income_eligible_HCIP(li_family_size,ld_monthly_gross_income)

        if (is_currently_working == 'Y' && health_insurance =='N' &&  income_eligible_HCIP_eligible == true)

               # programs_list[1] ="HCIP"
               result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 23 #"Medical (HCIP)"
				result_object.save

        end
         # ******************************"HCIP" Rules************************************end***************

         # *********************************4.	Cash and work support (TANF)***************start*********
        li_adult_count = PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) >= 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count
        li_child_count = PrescreenHouseholdMember.where("EXTRACT(YEAR FROM AGE(prescreen_household_members.date_of_birth)) < 18
        		                              and prescreen_household_id = ?",arg_prescreen_household_id).count
        ld_monthly_resource = get_monthly_resource(arg_prescreen_household_id)
        if ( ld_monthly_gross_income <= 223.00 	&& ld_monthly_resource <= 3000 	&& li_child_count > 0	&& li_adult_count > 0)
           # programs_list[1] ="TEA"
            income_eligible_tea_result = true
            result_object = PrescreenHouseholdResult.new
			result_object.prescreen_household_id = arg_prescreen_household_id
			result_object.service_program_category_id = 26 #"Cash and work support (TANF)"
			result_object.save
        else
        	income_eligible_tea_result = false
        end

         # *********************************4.	Cash and work support (TANF)***************end*********

         #***************************** IT Academy, CRC *******************************start
         self_sufficient = get_are_you_self_sufficient(arg_prescreen_household_id)

        # if (is_currently_working == 'Y' && self_sufficient =='N')

        #      # SNAP and TEA should not be populates above
        #     if income_eligible_tea_result == false && income_eligible_snap_result == false
               # programs_list[1] ="IT Academy"
                result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 14 #"IT Academy"
				result_object.save
               # programs_list[2] ="CRC"
                 result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 13 #"Career Readiness Certification"
				result_object.save

				# programs_list[2] ="Job search services"
                 result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 28 #"Job search services"
				result_object.save
        #     end

        # end
         #***************************** IT Academy, CRC*******************************end********

         # ****************************Disabled Veterans program**********************start
         # "Disabled Veterans " Rules
         is_veteran = get_veteran(arg_prescreen_household_id)
        if (is_currently_working == 'Y'	&& self_sufficient =='N' && is_veteran =='Y'  	&& disbality_found == 'Y')

             # SNAP and TEA should not be populates above
               # SNAP and TEA should not be populates above
            if income_eligible_tea_result == false && income_eligible_snap_result == false
            	result_object = PrescreenHouseholdResult.new
				result_object.prescreen_household_id = arg_prescreen_household_id
				result_object.service_program_category_id = 9 #"Disabled Veterans Outreach Program"
				result_object.save
            end


        end
         # ****************************Disabled Veterans program**********************end****

         # b.	Are you currently working? No
		# i.	Employer Initiated –
		# 1.	Laid off check =
		# Workforce Investment programs result
		# and Unemployment Insurance (if not selected in previous screen)

		# ****************Workforce Investment programs & Unemployment Insurance ********************start
		ls_laid_off_reason_found = laid_off_reason_found(arg_prescreen_household_id)
		if is_currently_working == 'N' && ls_laid_off_reason_found == 'Y'
			result_object = PrescreenHouseholdResult.new
			result_object.prescreen_household_id = arg_prescreen_household_id
			result_object.service_program_category_id = 5 #"Unemployment Insurance"
			result_object.save

			result_object = PrescreenHouseholdResult.new
			result_object.prescreen_household_id = arg_prescreen_household_id
			result_object.service_program_category_id = 27 #"Workforce Investment programs"
			result_object.save
		end

		# ****************Workforce Investment programs  & Unemployment Insurance ********************end

		# #ii.	Job Opportunity
# 1.	Jobs were outsourced
#    or
#    company closure = Workforce Investment programs in the result

# *********************Workforce Investment programs *******************************start
	ls_jobs_outsourced = jobs_outsourced_reason_found(arg_prescreen_household_id)
	ls_company_closure = company_closure_reason_found(arg_prescreen_household_id)
	if is_currently_working == 'N' && ( ls_jobs_outsourced == 'Y'||  ls_company_closure == 'Y')
		result_object = PrescreenHouseholdResult.new
		result_object.prescreen_household_id = arg_prescreen_household_id
		result_object.service_program_category_id = 27 #"Workforce Investment programs"
		result_object.save
	end

# *********************Workforce Investment programs *******************************end

# ************************"Workforce Investment Act"*******************start
	ls_unemployed_more_than_year = unemployed_more_than_year_reason_found(arg_prescreen_household_id)
	if is_currently_working == 'N' && ls_unemployed_more_than_year == 'Y'
		result_object = PrescreenHouseholdResult.new
		result_object.prescreen_household_id = arg_prescreen_household_id
		result_object.service_program_category_id = 27 #""Workforce Investment Act"
		result_object.save
	end


# ************************"Workforce Investment Act"*******************end

end





        def income_eligible_SNAP(family_size,monthly_gross_income)
                if  family_size == 1 && monthly_gross_income <= 1276
                                return true
                end
                if  family_size == 2 && monthly_gross_income <= 1726
                                return true
                end
                if  family_size == 3 && monthly_gross_income <= 2177
                                return true
                end
                if  family_size == 4 && monthly_gross_income <= 2628
                                return true
                end
                if  family_size == 5 && monthly_gross_income <= 3078
                                return true
                end
                if  family_size == 6 && monthly_gross_income <= 3529
                                return true
                end
                if  family_size == 7 && monthly_gross_income <= 3980
                                return true
                end
                if  family_size == 8 && monthly_gross_income <= 4430
                                return true
                end
                if  family_size == 9 && monthly_gross_income <= 4881
                                return true
                end
                if  family_size == 10 && monthly_gross_income <= 5332
                                return true
                end
            return false
        end

		def income_eligible_HCIP(family_size,monthly_gross_income)
                if  family_size == 1 && monthly_gross_income <= 1304.51
                                return true
                end
                if  family_size == 2 && monthly_gross_income <= 1765.58
                                return true
                end
                if  family_size == 3 && monthly_gross_income <= 2226.64
                end
                if  family_size == 4 && monthly_gross_income <= 2687.71
                                return true
                end
                if  family_size == 5 && monthly_gross_income <= 3148.78
                                return true
                end

                if  family_size > 5 && monthly_gross_income <= 3148.78 + (461.07 * (family_size - 5 ))
                                return true
                end



            return false
		end





        # def get_monthly_expense(arg_prescreen_household_id)
        # 	household = PrescreenHousehold.where("id = ?",arg_prescreen_household_id).first
        # 	return household.household_expense_amount
        # end



 end







#   	def return_program_eligible(arg_prescreen_household_id)
#         programs_list = Array.new

#         only_adults_between_17_and_50 = get_only_adults_between_17_and_50()
#         no_kids = get_no_kids()
#         # no_kids_with_no_ssi = no_kids_with_no_ssi()

#         no_pregnant = get_no_pregnant()
#         no_disbaled = get_no_disbaled()
#         no_high_school_or_college = get_no_high_school_or_college()
#         not_receiving_UI_or_TEA = get_not_receiving_UI_or_TEA()
#         family_size = get_family_size()
#         monthly_gross_income = get_monthly_gross_income()
#         monthly_expense = get_monthly_expense()
#         monthly_resource = get_monthly_resource()
#         all_members_receiving_ssi = get_all_members_receiving_ssi()
#         are_you_currently_working = get_are_you_currently_working()
#         no_insurance = get_no_insurance()
#         no_self_sufficient = no_self_sufficient()
#         is_veteran = get_is_veteran()
#         is_currently_working = get_is_currently_working()


# # "TEA " Rules
#         if (no_kids_with_no_ssi > 0 &&  monthly_gross_income <= 223.00 && monthly_resource <= 3000)

#            programs_list[1] ="TEA"
#         end

# # "SNAP E&T" Rules
#         if (only_adults_between_17_and_50 =='Y' &&
#            no_kids == 'Y' &&
#            no_pregnant == 'Y' &&
#                                    no_disbaled == 'Y' &&
#                                    no_high_school_or_college == 'Y' &&
#                                    not_receiving_UI_or_TEA == 'Y' &&
#            income_eligible_SNAP == true)

#            programs_list[1] ="SNAP E&T"
#         end

# # "SNAP" Rules
#         if all_members_receiving_ssi =='Y'
#            programs_list[1] ="SNAP E&T"
#         else
#                 if   income_eligible_SNAP == true
#                programs_list[1] ="SNAP E&T"
#            end
#         end

# # "HCIP" Rules
#         if (is_currently_working == 'Y' && no_insurance =='Y'  &&  income_eligible_HCIP == true)
#                programs_list[1] ="HCIP"

#         end

# # "IT Academy, CRC" Rules
#         if (is_currently_working == 'Y' && no_self_sufficient =='Y')

#              SNAP and TEA should not be populates above

#                programs_list[1] ="IT Academy"
#                programs_list[2] ="CRC"

#         end

# # "Disabled Veterans " Rules
#         if (is_currently_working == 'Y' && no_self_sufficient =='Y' && is_veteran =='Y' && no_disbaled == 'N')

#              SNAP and TEA should not be populates above

#                programs_list[1] ="IT Academy"
#                programs_list[2] ="CRC"

        # end