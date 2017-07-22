class EligibilityDetermineServiceScreeningOnly

	def self.common_rules_for_all_tanf_service_programs(arg_family_struct)
		@family_struct = arg_family_struct
		eligibility_time_limits_validation
		# validate_child_rule

		validate_minimum_one_child_present_rule
		# program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
 		# if ProgramUnitParticipation.is_program_unit_participation_status_open(program_wizard_object.program_unit_id) == false
		# 	# This should be checked only if program unit is not open - don't check this during redetermination.
		# 	check_if_any_of_the_member_is_already_in_open_tanf_program
		# end
		# check_if_any_of_the_member_has_already_received_payment_for_the_validation_date
		return @family_struct
	end

	def self.check_if_any_of_the_member_is_already_in_open_tanf_program
		# validations for active members
		@family_struct.members_list.each do |client_obj|
			result_hash = ProgramUnit.open_tanf_program_unit_found?(client_obj.client_id,@family_struct)
			if result_hash[:open_tanf_case_found] == true # member active in another program
				case result_hash[:service_program_id]
				when 1 #Service Program  = "TEA"
					insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_obj.client_id, 6118) # Client is already open in a TEA program
					update_budget_eligibility_indicator(@family_struct.run_id)
					#insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6118, result == "Eligible")# Client is already open in a TEA program
				when 4 #Service Program  = "Work Pays"
					insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_obj.client_id, 6120) # Client is already open in a Work Pays program
					update_budget_eligibility_indicator(@family_struct.run_id)
				end
			else # member not active in any other program, check if he is acting as caretaker in another program
				if ProgramUnitMember.is_client_acting_as_care_taker_in_any_other_open_program(client_obj.client_id, @family_struct.program_unit_id)
					insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_obj.client_id, 6334) # This Client is caretaker in another Open Program Unit, So you cannot become active member.
					update_budget_eligibility_indicator(@family_struct.run_id)
				end
			end
		end
		# Caretake is self with status inactive full, so check if the care taker is marked as active in anyother open program
		care_takers = ProgramBenefitMember.get_care_taker_list(@family_struct.program_wizard_id)
		care_takers.each do |care_taker|
			result_hash = ProgramUnit.open_tanf_program_unit_found?(care_taker.client_id,@family_struct)
			if result_hash[:open_tanf_case_found] == true # member active in another program
				insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, care_taker.client_id, 6333) # This Client is active in another Open Program Unit,So you cannot become Caretaker.
				update_budget_eligibility_indicator(@family_struct.run_id)
			end
		end
	end

	# def self.check_if_any_of_the_member_has_already_received_payment_for_the_validation_date
	# 	@family_struct.members_list.each do |client_obj|
	# 		if ProgramUnit.has_tanf_client_already_received_payment?(client_obj.client_id,@family_struct.service_program_id,@family_struct.run_id)
	# 			insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_obj.client_id, 6124) # Client was eligible in another TANF program
	# 			update_budget_eligibility_indicator(@family_struct.run_id)
	# 		end
	# 	end
	# end



	def self.tea_program_eligibility_validations(arg_family_struct)
		# tea_casetype_validate_rule(arg_ed_wizard_id)

		arg_family_struct.active_members.each do |client_id|
			# result = ProgramEligibilityService.check_if_the_client_is_already_enrolled_in_a_tea_program(@family_struct.service_program_id, client.client_id)
			# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6118, result == "Eligible")# Client is already open in a TEA program
			result = ProgramEligibilityService.check_for_tea_diversion_within_hundred_days(client_id)
			if result !=  "Potentially Eligible"
				arg_family_struct.ineligible_codes[client_id] << 6119
				# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6119) # Client has received TEA Diversion payment within 100 days
				# update_budget_eligibility_indicator(@family_struct.run_id)
				# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6119, result == "Eligible") # Client has received TEA Diversion payment within 100 days
			end
		end

		return arg_family_struct
	end

	def self.tea_diversion_program_eligibility_validations(arg_family_struct)
		@family_struct = arg_family_struct
		# validate_minimum_one_adult_present_rule(arg_ed_wizard_id)
		atleast_one_adult_has_valid_employement = false
		@family_struct.active_members.each do |client_id|
			if Client.is_adult(client_id)
				result = ProgramEligibilityService.check_for_valid_employment_for_the_client(client_id)
				if result ==  "Potentially Eligible"
					atleast_one_adult_has_valid_employement = true
					break
				end
			end
		end
		if atleast_one_adult_has_valid_employement
			check_if_any_adult_in_family_composition_receieved_tea_diversion_payment
		else
			@family_struct.ineligible_codes[0] << 6570
		end

		tea_diversion_assessment_requirements

		tea_diversion_payment_requirements

		return @family_struct
	end

	def self.tea_diversion_assessment_requirements
		atleast_one_of_family_members_has_valid_tea_diversion_requirements = false
		@family_struct.active_members.each do |client_id|
			if ClientAssessmentAnswer.does_this_client_need_tea_diversion_based_on_assessment?(client_id)
				atleast_one_of_family_members_has_valid_tea_diversion_requirements = true
				break
			end
		end
		unless atleast_one_of_family_members_has_valid_tea_diversion_requirements
			@family_struct.ineligible_codes[0] << 6760
		end
	end

	def self.tea_diversion_payment_requirements
		atleast_one_of_family_members_received_diversion_payemnts = false
		@family_struct.active_members.each do |client_id|
			if InStatePayment.check_for_diversion_payments(client_id)
				atleast_one_of_family_members_received_diversion_payemnts = true
				break
			end
		end
		if atleast_one_of_family_members_received_diversion_payemnts
			@family_struct.ineligible_codes[0] << 6761
		end
	end

	def self.check_if_any_adult_in_family_composition_receieved_tea_diversion_payment
		@family_struct.active_members.each do |client_id|
			result = ProgramEligibilityService.check_diversion_eligibility(@family_struct.service_program_id,client_id)
			if result !=  "Potentially Eligible"
				@family_struct.ineligible_codes[client_id] << 6125
				# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence,client_id, 6125) # Client has already received a one life time TEA Diversion payment
				# update_budget_eligibility_indicator(@family_struct.run_id)
			end
		end
	end

	def self.work_pays_program_eligibility_validations(arg_family_struct)
		@family_struct = arg_family_struct
 		# validate_minimum_one_adult_present_rule(arg_ed_wizard_id)
 		has_active_employment_more_than_24_hours
 		# program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)

 		# if ProgramUnitParticipation.is_program_unit_participation_status_open(program_wizard_object.program_unit_id) == false
 			# Program Unit is open - no need to check these - these need to be checked only if program unit is not yet open/ or closed.
	 		result = check_for_any_member_with_a_tea_case_closed_in_last_six_months
	 		if result == "Potentially Eligible"
	 			result = check_for_any_member_with_a_tea_case_has_received_a_minimum_of_three_tea_payments
	 		end

			@family_struct.active_members.each do |client_id|
		 		result = ProgramEligibilityService.check_for_tea_diversion_within_hundred_days(client_id)
				if result !=  "Potentially Eligible"
					@family_struct.ineligible_codes[client_id] << 6119
					# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6119) # Client has received TEA Diversion payment within 100 days
					# update_budget_eligibility_indicator(@family_struct.run_id)
					# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6119, result == "Eligible") # Client has received TEA Diversion payment within 100 days
				end
			end


			@family_struct.active_members.each do |client_id|
		        result = ProgramEligibilityService.check_wheather_client_has_three_months_sanctions_for_six_months_of_workpays(client_id)
				if result !=  "Potentially Eligible"
				 	@family_struct.ineligible_codes[client_id] << 6545
					# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6545) # Client has received TEA Diversion payment within 100 days
					# update_budget_eligibility_indicator(@family_struct.run_id)
					# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6119, result == "Eligible") # Client has received TEA Diversion payment within 100 days
				end
			end
	 	# end
	 	return 	@family_struct

		# if @family_struct.members_list.present?
		# 	@family_struct.members_list.each do |client_obj|
		# 		# result = ProgramEligibilityService.check_if_the_client_is_already_enrolled_in_a_work_pays_program(@family_struct.service_program_id, client.client_id)
		# 		# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6120, result == "Eligible") # Client is already open in a Work Pays program
		# 		result = ProgramEligibilityService.check_for_tea_case_closed_with_in_last_six_months(client_obj.client_id)
		# 		if result !=  "Eligible"
		# 			insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_obj.client_id, 6121) # Client does not have a closed TEA case within last six months"
		# 			#Rails.logger.debug("-->#{@family_struct.run_id}, #{@family_struct.month_sequence}, #{client}, #{CodetableItem.get_short_description(6121)}")
		# 			update_budget_eligibility_indicator(@family_struct.run_id)
		# 			#insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6121, result == "Eligible")# Client does not have a closed TEA case within last six months"
		# 		end
		# 	end
		# end

		# if @family_struct.adult_list.present?
		# 	result = ""
		# 	@family_struct.adult_list.each do |client|
		# 		result = ProgramEligibilityService.check_if_client_has_received_a_minimum_of_three_tea_payments(client)
		# 		if result ==  "Eligible"
		# 			break
		# 		end
		# 	end

		# 	if result !=  "Eligible"
		# 		insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6122) # No client within the program has received a minimum of three life time TEA payments
		# 		#insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client, 6122) #"No client within the program has received a minimum of three life time TEA payments"
		# 		update_budget_eligibility_indicator(@family_struct.run_id)
		# 		#insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6122, result == "Eligible") #"No client within the program has received a minimum of three life time TEA payments"
		# 	end
		# end
	end

	def self.has_active_employment_more_than_24_hours
		result = false
		case @family_struct.case_type
		when 6046
			@family_struct.active_members.each do |client_id|
				if Client.is_adult(client_id)
					employment_hours = EmploymentDetail.get_active_employment_for_client(client_id, @family_struct.validation_date)
					if employment_hours.present?
						if employment_hours >= 24
			           	   result = true
			           	else
			           	   result = false
			            end
					end
				end
		    end

		when 6047
			paid_work_hours_for_adults = 0
			@family_struct.active_members.each do |client_id|
				if Client.is_adult(client_id)
					employment_hours = EmploymentDetail.get_active_employment_for_client(client_id, @family_struct.validation_date)
					if employment_hours.present?
	                   paid_work_hours_for_adults = paid_work_hours_for_adults + employment_hours
	                end
				end
            end
            if paid_work_hours_for_adults.present?
				if paid_work_hours_for_adults >= 24
	           	   result = true
	           	else
	           	   result = false
	            end
			end
		end

		unless result
			@family_struct.ineligible_codes[0] << 6335
			# insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6335) # No income due to earnings with minimum 24 hours a week.
			# update_budget_eligibility_indicator(@family_struct.run_id)
		end
	end

	def self.check_for_any_member_with_a_tea_case_closed_in_last_six_months
		# if @family_struct.adult_list.present?
			result = nil
			@family_struct.active_members.each do |client_id|
				if Client.is_adult(client_id)
					result = ProgramEligibilityService.check_for_tea_case_closed_with_in_last_six_months(client_id)
					if result ==  "Potentially Eligible"
						break
					end
				end
			end

			if result !=  "Potentially Eligible"
				@family_struct.ineligible_codes[0] << 6121
				# insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6121) # No client within the program has received a minimum of three life time TEA payments
				#insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client, 6122) #"No client within the program has received a minimum of three life time TEA payments"
				# update_budget_eligibility_indicator(@family_struct.run_id)
				#insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6122, result == "Eligible") #"No client within the program has received a minimum of three life time TEA payments"
			end
		# end
		return result
	end

	def self.check_for_any_member_with_a_tea_case_has_received_a_minimum_of_three_tea_payments
		result = ""
		@family_struct.active_members.each do |client_id|
			if Client.is_adult(client_id)
				result = ProgramEligibilityService.check_if_client_has_received_a_minimum_of_three_tea_payments(client_id)
				if result ==  "Potentially Eligible"
					break
				end
			end
		end

		if result.present? && result !=  "Potentially Eligible"
			@family_struct.ineligible_codes[0] << 6122
			# insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6122) # No client within the program has received a minimum of three life time TEA payments
			# update_budget_eligibility_indicator(@family_struct.run_id)
		end
		return result
	end

	def self.insert_eligibility_determine_result_for_client(arg_run_id, arg_month_sequence, arg_client_id, arg_message)
			ins_eligibility_determine_result = EligibilityDetermineResult.new
			ins_eligibility_determine_result.run_id = arg_run_id
			ins_eligibility_determine_result.month_sequence = arg_month_sequence
			ins_eligibility_determine_result.client_id = arg_client_id
			ins_eligibility_determine_result.message_type = arg_message
			ins_eligibility_determine_result.message_type_text = "Critical"
			Rails.logger.debug("insert_eligibility_determine_result_for_client arg_client_id = #{arg_client_id}, arg_message_type =  #{arg_message}")
			unless ins_eligibility_determine_result.save
				Rails.logger.debug("arg_client_id = #{arg_client_id}, arg_message_type =  #{arg_message}")

			end
	end

	def self.insert_eligibility_determine_result_for_program_unit(arg_run_id, arg_month_sequence, arg_id, arg_message)

		if arg_id.present?
			ins_eligibility_determine_result = EligibilityDetermineResult.new
			ins_eligibility_determine_result.run_id = arg_run_id
			ins_eligibility_determine_result.month_sequence = arg_month_sequence
			ins_eligibility_determine_result.program_unit_id = arg_id
			ins_eligibility_determine_result.message_type = arg_message
			if ins_eligibility_determine_result.valid?
				ins_eligibility_determine_result.save

			end
		end

	end

	def self.validate_child_rule
		case @family_struct.case_type
			when "Child Not Present"
				insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6126) #"Child Rule Fail"
				update_budget_eligibility_indicator(@family_struct.run_id)
			when "Single Parent Case" || "Two Parent Case"
				unless @family_struct.child_list.count > 0
					insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6126) #"Child Rule Fail"
					update_budget_eligibility_indicator(@family_struct.run_id)
				end
			when "Minor Parent Case"
				unless @family_struct.child_list.count > 1
					insert_eligibility_determine_result_for_program_unit(@family_struct.run_id, @family_struct.month_sequence, @family_struct.program_unit_id, 6126) #"Child Rule Fail"
					update_budget_eligibility_indicator(@family_struct.run_id)
				end
		end

	end

	def self.eligibility_time_limits_validation
		@family_struct.active_members.each do |client_id|
			if Client.is_adult(client_id)
				result = ClientCharacteristic.does_client_has_eligible_work_characteristics_to_avoid_time_limits_validations(client_id)
				time_limit_collection = TimeLimit.get_federal_count(client_id)
				unless result
					# Check for time limits
					if time_limit_collection.present?
						if @family_struct.service_program_id.present? && (@family_struct.service_program_id == 1 || @family_struct.service_program_id == 3)
							# Check if the client has any eligible work characteristics, to skip state time limits validation
							unless ClientCharacteristic.are_there_any_eligible_work_characteristics_to_skip_state_time_limits_validation(client_id, @family_struct.validation_date)
								if time_limit_collection.first.tea_state_count.present?
									if time_limit_collection.first.tea_state_count >= SystemParam.get_state_limits_count()
										@family_struct.ineligible_codes[client_id] << 6115
										# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6115) #TEA State Time Limits have been met
									end
								end
							end
						end
						if @family_struct.service_program_id.present? && @family_struct.service_program_id == 4
							if time_limit_collection.first.work_pays_state_count.present?
								if time_limit_collection.first.work_pays_state_count >= SystemParam.get_state_limits_count()
									@family_struct.ineligible_codes[client_id] << 6123
									# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6123) # Work Pays State Time Limits have been met
								end
							end
						end
						if time_limit_collection.first.federal_count.present? && @family_struct.service_program_id == 1
							if time_limit_collection.first.federal_count >= SystemParam.get_federal_limits_count()
								@family_struct.ineligible_codes[client_id] << 6116
								# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6116) # Federal Time Limits have been met
							end
						end
					end
				end

				if (time_limit_collection.present? && time_limit_collection.first.federal_count.present? && @family_struct.service_program_id == 4)
							# program_unit_collection = ProgramUnitParticipation.get_participation_status(@family_struct.program_unit_id)
					# Rails.logger.debug("program_unit_collection = #{program_unit_collection.inspect}")
					# if program_unit_collection.blank?
						if time_limit_collection.first.federal_count >= SystemParam.get_federal_limits_count()
							@family_struct.ineligible_codes[client_id] << 6116
							# insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client_id, 6116) # Federal Time Limits have been met
					    end
					# end
			    end
			end
		end

	end

	# def self.eligibility_time_limits_validation
	# 		if @family_struct.adult_list.present?
	# 			@family_struct.adult_list.each do |client|

	# 				result = ClientCharacteristic.does_client_has_eligible_work_characteristics_to_avoid_time_limits_validations(client)


	# 				unless result
	# 					# Check for time limits
	# 					time_limit_collection = TimeLimit.get_federal_count(client)

	# 					if time_limit_collection.present?

	# 						if @family_struct.service_program_id.present? && @family_struct.service_program_id == 1
	# 							# TEA
	# 							state_count_validation(client,@family_struct.run_id,@family_struct.month_sequence,6115,1)#TEA State Time Limits have been met


	# 						end

	# 						if @family_struct.service_program_id.present? && @family_struct.service_program_id == 4
	# 							# WORKPAYS
	# 							state_count_validation(client,@family_struct.run_id,@family_struct.month_sequence,6123,4)#WorkPays State Time Limits have been met

	# 						end


	# 						if time_limit_collection.first.federal_count > SystemParam.get_federal_limits_count()
	# 							insert_eligibility_determine_result_for_client(@family_struct.run_id, @family_struct.month_sequence, client, 6116) # Federal Time Limits have been met
	# 						end


	# 					end
	# 				end
	# 			end
	# 		end
	# end

	def self.update_budget_eligibility_indicator(arg_run_id)
		program_month_summaries = ProgramMonthSummary.get_program_month_summary_collection_from_run_id(arg_run_id)
		if program_month_summaries.present?
			program_month_summary = program_month_summaries.first
			program_month_summary.budget_eligible_ind = 'N'
			program_month_summary.save
		end
	end


	def self.is_child_present_in_ed_run_composition?(arg_ed_wizard_id)
		# Get Program wizard object from run id.
		# get program benefit members
		# how many kids are present?
		child_present_flag = false
		program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		program_benefit_members_collection = program_wizard_object.program_benefit_members
		child_list = Array.new
		program_benefit_members_collection.each do |member_object|
			age = Client.get_age(member_object.client_id)
			if age != -1 && age < 18
				child_list << member_object
			elsif age == 18
                dob = Client.get_client_dob(member_object.client_id)
                if dob.month == Date.today.month
                    child_list << member_object
                end
			end
		end

		if child_list.size > 0
			child_present_flag = true
		end

		return child_present_flag
	end


	def self.validate_minimum_one_child_present_rule
		child_present_in_family_composition = false
		@family_struct.active_members.each do |client_id|
			if Client.is_child(client_id)
				child_present_in_family_composition = true
				break
			end
		end

		unless child_present_in_family_composition
			@family_struct.ineligible_codes[0] << 6126
		end
		# if is_child_present_in_ed_run_composition?(arg_ed_wizard_id) == false

		# 	program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		# 	insert_eligibility_determine_result_for_program_unit(program_wizard_object.run_id, program_wizard_object.month_sequence, program_wizard_object.program_unit_id, 6126) #"Child Rule Fail"

		# 	update_budget_eligibility_indicator(program_wizard_object.run_id)

		# end

	end


	def self.is_adult_present_in_ed_run_composition?(arg_ed_wizard_id)
		# Get Program wizard object from run id.
		# get program benefit members
		# how many Adults are present?
		adult_present_flag = false
		program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		program_benefit_members_collection = program_wizard_object.program_benefit_members
		# Rails.logger.debug("program_benefit_members_collection = #{program_benefit_members_collection.inspect}")
		adult_collection = Array.new
		program_benefit_members_collection.each do |member_object|
			age = Client.get_age(member_object.client_id)
			# Rails.logger.debug("age = #{age.inspect}")
			if  age > 18
				adult_collection << member_object
			end
		end

		if adult_collection.size > 0
			adult_present_flag = true
		end

		return adult_present_flag
	end

	def self.validate_minimum_one_adult_present_rule
		# if is_adult_present_in_ed_run_composition?(arg_ed_wizard_id) == false
		# 	program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		# 	insert_eligibility_determine_result_for_program_unit(program_wizard_object.run_id, program_wizard_object.month_sequence, program_wizard_object.program_unit_id, 6140) #"Adult Not included in Eligibility Determination
		# 	update_budget_eligibility_indicator(program_wizard_object.run_id)
		# end

	end


	def self.tea_casetype_validate_rule
		# Rule
		# For Tea Service Program
		# Program Unit Case Type - single Parent and 2 parent - ADult selection in ED composition is a must.
		# program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		# program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)

		case @family_struct.case_type
		when 6046,6047 # "Two Parent Case" || Single Parent Case"
			validate_minimum_one_adult_present_rule
		when 6049 # "Minor Parent Case"
			# Create a warning message if no adult is included in a minor parent case
			adult_present_in_family_composition = false
			@family_struct.member.each do |client_id|
				if Client.is_adult(client_id)
					adult_present_in_family_composition = true
					break
				end
			end
			unless adult_present_in_family_composition
				@family_struct.ineligible_codes[0] << 6140
			end
		end
	end



	def self.is_parent_present_in_ed_run_composition?(arg_ed_wizard_id)
		# Get Program wizard object from run id.
		# get program benefit members
		# how many Adults are present?
		parent_present_flag = false
		parents_list = Array.new
		program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		program_benefit_members_collection = program_wizard_object.program_benefit_members
		program_benefit_members_collection.each do |member_object|
			program_benefit_members_collection.each do |parent_object|
				if ClientRelationship.is_there_a_child_parent_relationship_between_clients(member_object.client_id,parent_object.client_id)
					parents_list << parent
				end
			end
		end

		if parents_list.size > 0
			parent_present_flag = true
		end

		return parent_present_flag
	end


	def self.validate_one_parent_should_be_present(arg_ed_wizard_id)
		if is_parent_present_in_ed_run_composition?(arg_ed_wizard_id) == false
			program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
			insert_eligibility_determine_result_for_program_unit(program_wizard_object.run_id, program_wizard_object.month_sequence, program_wizard_object.program_unit_id, 6141) #"Parent Not included in Eligibility Determination
			update_budget_eligibility_indicator(program_wizard_object.run_id)
		end
	end


	def self.state_count_validation(arg_client_id,arg_run_id,arg_month_sequence,arg_msg_id,arg_service_program_id)
		# for TEA & WORKPAYS
		l_param_out_of_state_count = SystemParam.get_key_value(10,"OUT_OF_STATE_COUNT","Out of State count")
		l_param_out_of_state_count = l_param_out_of_state_count.to_i
		l_out_of_state_count_for_client = OutOfStatePayment.get_out_of_state_payment_count_for_client(arg_client_id)
		time_limit_collection = TimeLimit.get_federal_count(arg_client_id)
		if (arg_service_program_id == 1 || arg_service_program_id == 3)
			service_program_state_count = time_limit_collection.first.tea_state_count
		elsif arg_service_program_id == 4
			service_program_state_count = time_limit_collection.first.work_pays_state_count
		end

		if l_out_of_state_count_for_client > l_param_out_of_state_count
			l_check_count = (SystemParam.get_state_limits_count() - (l_out_of_state_count_for_client - l_param_out_of_state_count))
			# l_check_count = (24 - (38 - 36))
			if service_program_state_count > l_check_count
				insert_eligibility_determine_result_for_client(arg_run_id, arg_month_sequence, arg_client_id, arg_msg_id)
			end
		else
			if service_program_state_count > SystemParam.get_state_limits_count()
				insert_eligibility_determine_result_for_client(arg_run_id, arg_month_sequence, arg_client_id, arg_msg_id)
			end
		end
	end



	def self.update_program_month_summaries_ed_indicator(arg_run_id,arg_month_sequence)
		program_month_summaries = ProgramMonthSummary.get_program_month_summary_collection_from_run_id(arg_run_id)
		if program_month_summaries.present?
			# Check in ED result table
			ed_result_program_unit_level_collection = EligibilityDetermineResult.where("run_id = ? and month_sequence = ? and program_unit_id is not null",arg_run_id,arg_month_sequence)
			ed_result_client_level_collection = EligibilityDetermineResult.where("run_id = ? and month_sequence = ? and client_id is not null and message_type_text = 'Critical'",arg_run_id,arg_month_sequence)

			if ed_result_program_unit_level_collection.present? || ed_result_client_level_collection.present?
				program_month_summary = program_month_summaries.first
				program_month_summary.budget_eligible_ind = 'N'
				program_month_summary.save
			end
		end
	end



end