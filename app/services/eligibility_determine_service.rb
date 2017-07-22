class EligibilityDetermineService

	def self.common_rules_for_all_tanf_service_programs(arg_family_type_struct,arg_ed_wizard_id)
		eligibility_time_limits_validation(arg_family_type_struct)
		# validate_child_rule(arg_family_type_struct)

		validate_minimum_one_child_present_rule(arg_ed_wizard_id)
		program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
 		if ProgramUnitParticipation.is_program_unit_participation_status_open(program_wizard_object.program_unit_id) == false
			# This should be checked only if program unit is not open - don't check this during redetermination.
			check_if_any_of_the_member_is_already_in_open_tanf_program(arg_family_type_struct)
		end
		check_if_any_of_the_member_has_already_received_payment_for_the_run_month(arg_family_type_struct)
	end

	def self.check_if_any_of_the_member_is_already_in_open_tanf_program(arg_family_type_struct)
		# validations for active members
		arg_family_type_struct.members_list.each do |client_obj|
			result_hash = ProgramUnit.open_tanf_program_unit_found?(client_obj.client_id,arg_family_type_struct)
			if result_hash[:open_tanf_case_found] == true # member active in another program
				case result_hash[:service_program_id]
				when 1 #Service Program  = "TEA"
					insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6118) # Client is already open in a TEA program
					update_budget_eligibility_indicator(arg_family_type_struct.run_id)
					#insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6118, result == "Eligible")# Client is already open in a TEA program
				when 4 #Service Program  = "Work Pays"
					insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6120) # Client is already open in a Work Pays program
					update_budget_eligibility_indicator(arg_family_type_struct.run_id)
				end
			else # member not active in any other program, check if he is acting as caretaker in another program
				if ProgramUnitMember.is_client_acting_as_care_taker_in_any_other_open_program(client_obj.client_id, arg_family_type_struct.program_unit_id)
					insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6334) # This Client is caretaker in another Open Program Unit, So you cannot become active member.
					update_budget_eligibility_indicator(arg_family_type_struct.run_id)
				end
			end
		end
		# Caretake is self with status inactive full, so check if the care taker is marked as active in anyother open program
		care_takers = ProgramBenefitMember.get_care_taker_list(arg_family_type_struct.program_wizard_id)
		care_takers.each do |care_taker|
			result_hash = ProgramUnit.open_tanf_program_unit_found?(care_taker.client_id,arg_family_type_struct)
			if result_hash[:open_tanf_case_found] == true # member active in another program
				insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, care_taker.client_id, 6333) # This Client is active in another Open Program Unit,So you cannot become Caretaker.
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
			end
		end
	end

	def self.check_if_any_of_the_member_has_already_received_payment_for_the_run_month(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client_obj|
			if ProgramUnit.has_tanf_client_already_received_payment?(client_obj.client_id,arg_family_type_struct.service_program_id,arg_family_type_struct.run_id)
				insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6124) # Client was eligible in another TANF program
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
			end
		end
	end



	def self.tea_program_eligibility_validations(arg_family_type_struct,arg_ed_wizard_id)
		tea_casetype_validate_rule(arg_ed_wizard_id)

		if arg_family_type_struct.members_list.present?
			arg_family_type_struct.members_list.each do |client_obj|
				# result = ProgramEligibilityService.check_if_the_client_is_already_enrolled_in_a_tea_program(arg_family_type_struct.service_program_id, client.client_id)
				# insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6118, result == "Eligible")# Client is already open in a TEA program
				result = ProgramEligibilityService.check_for_tea_diversion_within_hundred_days(client_obj.client_id)
				if result !=  "Potentially Eligible"
					insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6119) # Client has received TEA Diversion payment within 100 days
					update_budget_eligibility_indicator(arg_family_type_struct.run_id)
					# insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6119, result == "Eligible") # Client has received TEA Diversion payment within 100 days
				end
			end
		end
	end

	def self.tea_diversion_program_eligibility_validations(arg_family_type_struct,arg_ed_wizard_id)
		validate_minimum_one_adult_present_rule(arg_ed_wizard_id)
		check_if_atleast_one_adult_in_the_family_composition_has_valid_employemnt(arg_family_type_struct)
	end

	def self.check_if_atleast_one_adult_in_the_family_composition_has_valid_employemnt(arg_family_type_struct)
		atleast_one_adult_has_valid_employement = false
		arg_family_type_struct.adult_list.each do |client_id|
			result = ProgramEligibilityService.check_for_valid_employment_for_the_client(client_id)
			if result ==  "Potentially Eligible"
				atleast_one_adult_has_valid_employement = true
				break
			end
		end
		if atleast_one_adult_has_valid_employement
			check_if_any_adult_in_family_composition_receieved_tea_diversion_payment(arg_family_type_struct)
		else
			insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6570)
		    update_budget_eligibility_indicator(arg_family_type_struct.run_id)
		end
	end

	def self.check_if_any_adult_in_family_composition_receieved_tea_diversion_payment(arg_family_type_struct)
		arg_family_type_struct.adult_list.each do |client_id|
			result = ProgramEligibilityService.check_diversion_eligibility(arg_family_type_struct.service_program_id,client_id)
			if result !=  "Potentially Eligible"
				insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence,client_id, 6125) # Client has already received a one life time TEA Diversion payment
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
			end
		end
	end

	def self.work_pays_program_eligibility_validations(arg_family_type_struct,arg_ed_wizard_id)
 		validate_minimum_one_adult_present_rule(arg_ed_wizard_id)
 		has_active_employment_more_than_24_hours(arg_family_type_struct)
 		result = "Potentially Eligible"
 		program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)

 		if ProgramUnitParticipation.is_program_unit_participation_status_open(program_wizard_object.program_unit_id) == false
 			# Program Unit is open - no need to check these - these need to be checked only if program unit is not yet open/ or closed.
	 		result = check_for_any_member_with_a_tea_case_closed_in_last_six_months(arg_family_type_struct)
	 		if result == "Potentially Eligible"
	 			result = check_for_any_member_with_a_tea_case_has_received_a_minimum_of_three_tea_payments(arg_family_type_struct)
	 		end
	 		if arg_family_type_struct.members_list.present?
			  arg_family_type_struct.members_list.each do |client_obj|
		 		result = ProgramEligibilityService.check_for_tea_diversion_within_hundred_days(client_obj.client_id)
				if result !=  "Potentially Eligible"
					insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6119) # Client has received TEA Diversion payment within 100 days
					update_budget_eligibility_indicator(arg_family_type_struct.run_id)
					# insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6119, result == "Eligible") # Client has received TEA Diversion payment within 100 days
				end
			  end
			end
			if arg_family_type_struct.members_list.present?
			  arg_family_type_struct.members_list.each do |client_obj|
		         result = ProgramEligibilityService.check_wheather_client_has_three_months_sanctions_for_six_months_of_workpays(client_obj.client_id)
				 if result !=  "Potentially Eligible"
					insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6545) # Client has received TEA Diversion payment within 100 days
					update_budget_eligibility_indicator(arg_family_type_struct.run_id)
					# insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6119, result == "Eligible") # Client has received TEA Diversion payment within 100 days
				 end
				end
			end
	 	end
	 	return 	result

		# if arg_family_type_struct.members_list.present?
		# 	arg_family_type_struct.members_list.each do |client_obj|
		# 		# result = ProgramEligibilityService.check_if_the_client_is_already_enrolled_in_a_work_pays_program(arg_family_type_struct.service_program_id, client.client_id)
		# 		# insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6120, result == "Eligible") # Client is already open in a Work Pays program
		# 		result = ProgramEligibilityService.check_for_tea_case_closed_with_in_last_six_months(client_obj.client_id)
		# 		if result !=  "Eligible"
		# 			insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client_obj.client_id, 6121) # Client does not have a closed TEA case within last six months"
		# 			#Rails.logger.debug("-->#{arg_family_type_struct.run_id}, #{arg_family_type_struct.month_sequence}, #{client}, #{CodetableItem.get_short_description(6121)}")
		# 			update_budget_eligibility_indicator(arg_family_type_struct.run_id)
		# 			#insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6121, result == "Eligible")# Client does not have a closed TEA case within last six months"
		# 		end
		# 	end
		# end

		# if arg_family_type_struct.adult_list.present?
		# 	result = ""
		# 	arg_family_type_struct.adult_list.each do |client|
		# 		result = ProgramEligibilityService.check_if_client_has_received_a_minimum_of_three_tea_payments(client)
		# 		if result ==  "Eligible"
		# 			break
		# 		end
		# 	end

		# 	if result !=  "Eligible"
		# 		insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6122) # No client within the program has received a minimum of three life time TEA payments
		# 		#insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6122) #"No client within the program has received a minimum of three life time TEA payments"
		# 		update_budget_eligibility_indicator(arg_family_type_struct.run_id)
		# 		#insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6122, result == "Eligible") #"No client within the program has received a minimum of three life time TEA payments"
		# 	end
		# end
	end

	def self.has_active_employment_more_than_24_hours(arg_family_type_struct)
		result = false
		case arg_family_type_struct.case_type_integer
		when 6046
			arg_family_type_struct.adult_list.each do |client|
				employment_hours = EmploymentDetail.get_active_employment_for_client(client, arg_family_type_struct.run_month)
				if employment_hours.present?
					if employment_hours >= 24
		           	   result = true
		           	else
		           	   result = false
		            end
				end
		    end

		when 6047
			paid_work_hours_for_adults = 0
				arg_family_type_struct.adult_list.each do |client|
					employment_hours = EmploymentDetail.get_active_employment_for_client(client, arg_family_type_struct.run_month)
					if employment_hours.present?
	                   paid_work_hours_for_adults = paid_work_hours_for_adults + employment_hours
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
			insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6335) # No income due to earnings with minimum 24 hours a week.
			update_budget_eligibility_indicator(arg_family_type_struct.run_id)
		end
	end

	def self.check_for_any_member_with_a_tea_case_closed_in_last_six_months(arg_family_type_struct)
		if arg_family_type_struct.adult_list.present?
			result = ""
			arg_family_type_struct.adult_list.each do |client|
				result = ProgramEligibilityService.check_for_tea_case_closed_with_in_last_six_months(client)
				if result ==  "Potentially Eligible"
					break
				end
			end

			if result !=  "Potentially Eligible"
				insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6121) # No client within the program has received a minimum of three life time TEA payments
				#insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6122) #"No client within the program has received a minimum of three life time TEA payments"
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
				#insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6122, result == "Eligible") #"No client within the program has received a minimum of three life time TEA payments"
			end
		end
		return result
	end

	def self.check_for_any_member_with_a_tea_case_has_received_a_minimum_of_three_tea_payments(arg_family_type_struct)
		if arg_family_type_struct.adult_list.present?
			result = ""
			arg_family_type_struct.adult_list.each do |client|
				result = ProgramEligibilityService.check_if_client_has_received_a_minimum_of_three_tea_payments(client)
				if result ==  "Potentially Eligible"
					break
				end
			end

			if result !=  "Potentially Eligible"
				insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6122) # No client within the program has received a minimum of three life time TEA payments
				#insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6122) #"No client within the program has received a minimum of three life time TEA payments"
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
				#insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6122, result == "Eligible") #"No client within the program has received a minimum of three life time TEA payments"
			end
		end
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

	def self.validate_child_rule(arg_family_type_struct)
		case arg_family_type_struct.case_type
		when "Child Not Present"
			insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6126) #"Child Rule Fail"
			update_budget_eligibility_indicator(arg_family_type_struct.run_id)
		when "Single Parent Case" || "Two Parent Case"
			unless arg_family_type_struct.child_list.count > 0
				insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6126) #"Child Rule Fail"
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
			end
		when "Minor Parent Case"
			unless arg_family_type_struct.child_list.count > 1
				insert_eligibility_determine_result_for_program_unit(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, arg_family_type_struct.program_unit_id, 6126) #"Child Rule Fail"
				update_budget_eligibility_indicator(arg_family_type_struct.run_id)
			end
		end
	end

	def self.eligibility_time_limits_validation(arg_family_type_struct)
		if arg_family_type_struct.adult_list.present?
			arg_family_type_struct.adult_list.each do |client|
				result = ClientCharacteristic.does_client_has_eligible_work_characteristics_to_avoid_time_limits_validations(client)
				time_limit_collection = TimeLimit.get_federal_count(client)
				unless result
					# Check for time limits
					if time_limit_collection.present?
						if arg_family_type_struct.service_program_id.present? && (arg_family_type_struct.service_program_id == 1 || arg_family_type_struct.service_program_id == 3)
							# Check if the client has any eligible work characteristics, to skip state time limits validation
							unless ClientCharacteristic.are_there_any_eligible_work_characteristics_to_skip_state_time_limits_validation(client, arg_family_type_struct.run_month)
								if time_limit_collection.first.tea_state_count.present?
									if time_limit_collection.first.tea_state_count >= SystemParam.get_state_limits_count()
										insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6115) #TEA State Time Limits have been met
									end
								end
							end
						end
						if arg_family_type_struct.service_program_id.present? && arg_family_type_struct.service_program_id == 4
							if time_limit_collection.first.work_pays_state_count.present?
								if time_limit_collection.first.work_pays_state_count >= SystemParam.get_state_limits_count()
									insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6123) # Work Pays State Time Limits have been met
								end
							end
						end
						if time_limit_collection.first.federal_count.present? && arg_family_type_struct.service_program_id == 1
							if time_limit_collection.first.federal_count >= SystemParam.get_federal_limits_count()
								insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6116) # Federal Time Limits have been met
							end
						end
					end
				end

				if (time_limit_collection.present? && time_limit_collection.first.federal_count.present? && arg_family_type_struct.service_program_id == 4)
					program_unit_collection = ProgramUnitParticipation.get_participation_status(arg_family_type_struct.program_unit_id)
					# Rails.logger.debug("program_unit_collection = #{program_unit_collection.inspect}")
					if program_unit_collection.blank?
						if time_limit_collection.first.federal_count >= SystemParam.get_federal_limits_count()
						insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6116) # Federal Time Limits have been met
					    end
					end
			    end
			end
		end
	end

	# def self.eligibility_time_limits_validation(arg_family_type_struct)
	# 		if arg_family_type_struct.adult_list.present?
	# 			arg_family_type_struct.adult_list.each do |client|

	# 				result = ClientCharacteristic.does_client_has_eligible_work_characteristics_to_avoid_time_limits_validations(client)


	# 				unless result
	# 					# Check for time limits
	# 					time_limit_collection = TimeLimit.get_federal_count(client)

	# 					if time_limit_collection.present?

	# 						if arg_family_type_struct.service_program_id.present? && arg_family_type_struct.service_program_id == 1
	# 							# TEA
	# 							state_count_validation(client,arg_family_type_struct.run_id,arg_family_type_struct.month_sequence,6115,1)#TEA State Time Limits have been met


	# 						end

	# 						if arg_family_type_struct.service_program_id.present? && arg_family_type_struct.service_program_id == 4
	# 							# WORKPAYS
	# 							state_count_validation(client,arg_family_type_struct.run_id,arg_family_type_struct.month_sequence,6123,4)#WorkPays State Time Limits have been met

	# 						end


	# 						if time_limit_collection.first.federal_count > SystemParam.get_federal_limits_count()
	# 							insert_eligibility_determine_result_for_client(arg_family_type_struct.run_id, arg_family_type_struct.month_sequence, client, 6116) # Federal Time Limits have been met
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
			program_month_summary.save!
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


	def self.validate_minimum_one_child_present_rule(arg_ed_wizard_id)
		if is_child_present_in_ed_run_composition?(arg_ed_wizard_id) == false
			program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
			insert_eligibility_determine_result_for_program_unit(program_wizard_object.run_id, program_wizard_object.month_sequence, program_wizard_object.program_unit_id, 6126) #"Child Rule Fail"

			update_budget_eligibility_indicator(program_wizard_object.run_id)
		end
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

	def self.validate_minimum_one_adult_present_rule(arg_ed_wizard_id)
		if is_adult_present_in_ed_run_composition?(arg_ed_wizard_id) == false
			program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
			insert_eligibility_determine_result_for_program_unit(program_wizard_object.run_id, program_wizard_object.month_sequence, program_wizard_object.program_unit_id, 6140) #"Adult Not included in Eligibility Determination
			update_budget_eligibility_indicator(program_wizard_object.run_id)
		end
	end


	def self.tea_casetype_validate_rule(arg_ed_wizard_id)
		# Rule
		# For Tea Service Program
		# Program Unit Case Type - single Parent and 2 parent - ADult selection in ED composition is a must.
		# program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
		# program_unit_object = ProgramUnit.find(program_wizard_object.program_unit_id)
		fts = FamilyTypeService.new
		family_type_struct = FamilyTypeStruct.new
		family_type_struct = fts.determine_family_type_for_program_wizard(arg_ed_wizard_id)
		# Rails.logger.debug("family_type_struct =#{family_type_struct.inspect}")
		if (family_type_struct.case_type == "Two Parent Case" || family_type_struct.case_type == "Single Parent Case" )
			validate_minimum_one_adult_present_rule(arg_ed_wizard_id)
		elsif (family_type_struct.case_type == "Minor Parent Case")
			adult_list =ProgramBenefitMember.get_active_adult_client_ids_associated_with_program_wizard_id(arg_ed_wizard_id)
			# Rails.logger.debug("adult_list = #{adult_list.inspect}")
			if adult_list.count > 0
			else
				# Create a warning message if no adult is included in a minor parent case
				if family_type_struct.adult_list.blank?
				program_wizard_object = ProgramWizard.find(arg_ed_wizard_id)
				ins_eligibility_determine_result = EligibilityDetermineResult.new
				ins_eligibility_determine_result.run_id = program_wizard_object.run_id
				ins_eligibility_determine_result.month_sequence = program_wizard_object.month_sequence
				ins_eligibility_determine_result.client_id = family_type_struct.parents_list[0]
				ins_eligibility_determine_result.message_type = 6140
				ins_eligibility_determine_result.message_type_text = "Warning"
				ins_eligibility_determine_result.save
			end

			end
			# Rails.logger.debug("family_type_struct = #{(family_type_struct.adult_list).inspect}")
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
		# Check in ED result table, if any business rules fail update program month summary eligibility indicator as 'N'
		ed_result_program_unit_level_collection = EligibilityDetermineResult.where("run_id = ? and month_sequence = ? and program_unit_id is not null",arg_run_id,arg_month_sequence)
		ed_result_client_level_collection = EligibilityDetermineResult.where("run_id = ? and month_sequence = ? and client_id is not null and message_type_text = 'Critical'",arg_run_id,arg_month_sequence)
		update_budget_eligibility_indicator(arg_run_id) if ed_result_program_unit_level_collection.present? || ed_result_client_level_collection.present?
	end
end