# Author  Kiran
# Modifications
# Manoj 09/29/2014
# Added determine_program_unit_eligibilty

class ApplicationEligibilityService

	def determine_application_eligibilty(arg_family_type_struct)
		# variables intitialized to distinguish the level of validation - Kiran 03/25/2015
		arg_family_type_struct.validation_level  = "APP"
		arg_family_type_struct.validation_date = arg_family_type_struct.application_date

		#Delete all the existing application eligibility results for clients associated with the application
		ApplicationEligibilityResults.delete_results_for_the_application(arg_family_type_struct.application_id)
		# To invoke common eleigibility rules across application, program unit and program wizard eligibility determination
		run_eligibility(arg_family_type_struct)

		# Eligibility rules for application level ed. All the rules specific to application alone should go in this method.
		eligibility_rules_for_application(arg_family_type_struct)
	end

	def determine_program_unit_eligibilty(arg_family_type_struct)
		# variables intitialized to distinguish the level of validation - Kiran 03/25/2015
		arg_family_type_struct.validation_level  = "PU"
		arg_family_type_struct.validation_date = arg_family_type_struct.application_date

		l_program_unit_object = ProgramUnit.find(arg_family_type_struct.program_unit_id)
		arg_family_type_struct.application_id = l_program_unit_object.client_application_id
		#Delete all the existing application eligibility results for clients associated with the program unit
		clients = ProgramUnit.get_clients_list_from_program_unit_id(arg_family_type_struct.program_unit_id)
		clients.each do |client|
			ApplicationEligibilityResults.delete_results_based_on_application_id_and_client_id(arg_family_type_struct.application_id, client.client_id)
		end
		# To invoke common eleigibility rules across application, program unit and program wizard eligibility determination
		run_eligibility(arg_family_type_struct)

		eligibility_rules_for_program_unit(arg_family_type_struct)
	end

	def determine_program_wizard_eligibilty(arg_family_type_struct)
		# variables intitialized to distinguish the level of validation - Kiran 03/25/2015
		arg_family_type_struct.validation_level  = "ED"
		arg_family_type_struct.validation_date = arg_family_type_struct.run_month

		arg_family_type_struct.application_id = ProgramWizard.get_application_id_from_program_wizard_id(arg_family_type_struct.program_wizard_id)
		#Delete all the existing application eligibility results for clients associated with the program wizard
		clients = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_family_type_struct.program_wizard_id)
		clients.each do |client|
			ApplicationEligibilityResults.delete_results_based_on_application_id_and_client_id(arg_family_type_struct.application_id, client.client_id)
		end
		#ApplicationEligibilityResults.delete_results_for_the_application(arg_family_type_struct.application_id)
		# To invoke common eleigibility rules across application, program unit and program wizard eligibility determination
		run_eligibility(arg_family_type_struct)

		eligibility_rules_for_program_wizard(arg_family_type_struct)

		validate_employment_information(arg_family_type_struct)
		# Not needed because the navigator is performing this check whereas when a new program creation is occured on Navigator page this validation should fire appropriately
		# validate_for_ssi_income_or_ssi_characteristics(arg_family_type_struct)
	end

	def run_eligibility(arg_family_type_struct)

		# In case of minor parent case or single parent case without a spouse relation, check for deprivation code for the kid
		# check_for_kid_deprivation_if_it_is_a_minor_parent_or_single_parent_case(arg_family_type_struct)
		# Check deprivation code for all children in the program except for the minor parent
		# check_deprivation_code_for_children_in_the_program(arg_family_type_struct)

		if arg_family_type_struct.validation_level  == "APP"
			if arg_family_type_struct.case_type_integer != 6048
				# Not equal to child only case
				validate_work_participation_characteristics(arg_family_type_struct)
			end
			#TEA diversion does not need warning messages for child education or immunization
			validate_immunization_for_children(arg_family_type_struct)
		    validate_education_for_children(arg_family_type_struct)

		else
			if arg_family_type_struct.service_program_id != 3 # Not TEA Diversion program
				if arg_family_type_struct.case_type_integer != 6048
					# Not equal to child only case
					validate_work_participation_characteristics(arg_family_type_struct)
				end
				#TEA diversion does not need warning messages for child education or immunization
				validate_immunization_for_children(arg_family_type_struct)
		        validate_education_for_children(arg_family_type_struct)

			end
		end
		# Check Felony and Parole characterisctics for all the adults within the application, if other characteristics exits
		# Not needed because the navigator is performing this check whereas when a new program creation is occured on Navigator page this validation should fire appropriately
		validate_other_characteristics(arg_family_type_struct)

		# Check resident status for all the members

		# validate_state_residence(arg_family_type_struct)

		# Check citizenship information for all the members
		validate_citizenship_information(arg_family_type_struct)
		validate_dob_information(arg_family_type_struct)
		validate_felon_characteristic(arg_family_type_struct)
		validate_tea_out_of_state_payments(arg_family_type_struct)
		validate_household_registration_completion(arg_family_type_struct)
		validate_race_information(arg_family_type_struct) if arg_family_type_struct.validate_race_information.blank?
		# validate_physical_address_information(arg_family_type_struct)
	end

	def validate_work_participation_characteristics(arg_family_type_struct)
		# If it's a 2 parent case, check for work particiapation for both the parents instead of checking it for all the adults
		case arg_family_type_struct.case_type_integer
		when 6047,6046
			# 6047 - Two parent case
			# 6046 - "Single Parent Case"
			# validate_presence_of_work_participation_for_parents(arg_family_type_struct)
		when 6049
			#"Minor Parent Case"
			validate_work_participation_characteristics_for_minor_parents(arg_family_type_struct)
		end

	end

	def validate_presence_of_work_participation_for_parents(arg_family_type_struct)
        arg_family_type_struct.parents_list.each do |parent|
			result = ""
			if arg_family_type_struct.validation_level == "ED"
				if arg_family_type_struct.service_program_id == 1
					result = ClientCharacteristic.has_work_registartion(parent, arg_family_type_struct.validation_date)
					insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6038, result) #WorkParticipation: 6038
				elsif arg_family_type_struct.service_program_id == 4 # The rule is applicable only for work pays and not for TEA Diversion by any chance
					if arg_family_type_struct.case_type_integer == 6047
						validate_work_charateristics_for_two_parent_case_for_work_pays(arg_family_type_struct)
					else
                      result = ClientCharacteristic.open_mandatory_work_characteristic_found?(parent, arg_family_type_struct.validation_date)
                      insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6337, result) #Mandatory Work Participation requirement
					end
				end
	        else
				if arg_family_type_struct.service_program_id == 1 || arg_family_type_struct.validation_level == "APP"
					characteritics_object = ClientCharacteristic.get_all_work_characteristic_records_for_the_client(parent).count > 0
					result = "#{characteritics_object}"
					insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6038, result) #WorkParticipation: 6038
				else

					if arg_family_type_struct.service_program_id == 4 # The rule is applicable only for work pays and not for TEA Diversion by any chance
						characteritics_object = ClientCharacteristic.get_all_work_characteristic_records_for_the_client(parent).count > 0
						result = "#{characteritics_object}"
						insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6038, result) #Mandatory Work Participation requirement
					end
				end
			end
		end
	end

	def validate_work_charateristics_for_two_parent_case_for_work_pays(arg_family_type_struct)
		mandatory_characteristics_present = false
		arg_family_type_struct.parents_list.each do |parent|
			mandatory_characteristics_present ||= ClientCharacteristic.open_mandatory_work_characteristic_found?(parent, arg_family_type_struct.validation_date)
			work_charaterstics = ClientCharacteristic.has_work_registartion(parent, arg_family_type_struct.validation_date)
			insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6038, work_charaterstics) #WorkParticipation: 6038
		end
		unless mandatory_characteristics_present
			arg_family_type_struct.parents_list.each do |parent|
				insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6337, false) #Mandatory Work Participation requirement
				break
			end
		end
	end

	def validate_other_characteristics(arg_family_type_struct)
		# Check for other characteristics violations only for all program members
		arg_family_type_struct.members_list.each do |client|
			check_for_violations(client.client_id,arg_family_type_struct)
		end
	end

	def check_for_violations(arg_client_id, arg_family_type_struct)
		result = ClientCharacteristic.has_valid_other_characteristic(arg_client_id, arg_family_type_struct.validation_date)
		insert_application_eligibility_result(arg_family_type_struct.application_id, arg_client_id, 6085, result)
	end

	def validate_immunization_for_children(arg_family_type_struct)
		# All children below 5 years should have an immunization record
		arg_family_type_struct.child_list.each do |child|
			age = Client.get_age(child)
			if age < 5
				result = Client.is_exempted_from_immunization(child) || ClientImmunization.is_there_an_immunization_associated(child)
				insert_application_eligibility_result(arg_family_type_struct.application_id, child, 6035, result) #Immunization: 6035
			end
		end
	end

	def validate_education_for_children(arg_family_type_struct)
		# All children greater than equal to 5 years should have education asscoiation
		# Minor Parent Education validation:
			# Check if the child is a minor parent check whether he has an education association.
			# Get the highest education qualification and check whether it is eleigible or not
			# In order for the education to be eligible, it should not be below 12th grade or kinder garten
		arg_family_type_struct.child_list.each do |child|
			age = Client.get_age(child)
			if age >= 5
				result = false
				if arg_family_type_struct.minor_parent_case.present? && arg_family_type_struct.minor_parent_case
					arg_family_type_struct.parents_list.each do |parent|
						if child == parent
							result = Education.check_if_minor_parent_has_an_eligible_education(parent)
							break
						end
					end
				else
					# Child who is not a minor parent.
					result = Education.is_there_an_education_associated(child)
				end

				insert_application_eligibility_result(arg_family_type_struct.application_id, child, 6036, result) #Education: 6036
			end
		end
	end

	def check_for_kid_deprivation_if_it_is_a_minor_parent_or_single_parent_case(arg_family_type_struct)
		if arg_family_type_struct.family_type == 1
			# In case of minor parent case or single parent case without a spouse relation, check for deprivation code for the kid
			if arg_family_type_struct.parents_list.count == 1
				if ( (arg_family_type_struct.minor_parent_case.present? && arg_family_type_struct.minor_parent_case) ||
						!ClientRelationship.is_there_a_spouse_relation_for_the_client(arg_family_type_struct.parents_list[0]) )
					result = ClientParentalRspability.is_there_a_deprivation_code_associated(arg_family_type_struct.child)
					insert_application_eligibility_result(arg_family_type_struct.application_id, arg_family_type_struct.child, 6037, result) #Deprivation: 6037
				else
					# This is a single parent case with a care taker, check if there is work participation for all the adults in the application
					# arg_family_type_struct.adult_list.each do |adult|
					# 	result = ClientCharacteristic.has_work_registartion(adult, arg_family_type_struct.run_month)
					# 	insert_application_eligibility_result(arg_family_type_struct.application_id, adult, 6038, result) #WorkParticipation: 6038
					# end
				end
			end
		end
	end

	def check_deprivation_code_for_children_in_the_program(arg_family_type_struct)
		# Rails.logger.debug("arg_family_type_struct.child_list = #{arg_family_type_struct.child_list}")
		arg_family_type_struct.child_list.each do |child|
			# Rails.logger.debug("ClientRelationship.is_there_a_parent_relationship(child) = #{ClientRelationship.is_there_a_parent_relationship(child)}")
			unless ClientRelationship.is_there_a_parent_relationship(child)
				result = ClientParentalRspability.is_there_a_deprivation_code_associated(child)
				insert_application_eligibility_result(arg_family_type_struct.application_id, child, 6037, result) #Deprivation: 6037
			end
		end
	end

	def validate_work_participation_characteristics_for_minor_parents(arg_family_type_struct)
		# Eligibility determination should handle if a work participation for the given month is provided or not .
		Rails.logger.debug("validate_work_participation_characteristics_for_minor_parents - mnore parents list #{arg_family_type_struct.parents_list}")
		arg_family_type_struct.parents_list.each do |parent|
			result = ""
			if arg_family_type_struct.validation_level == "ED"
				if arg_family_type_struct.service_program_id == 1
					result = ClientCharacteristic.has_valid_minor_parent_work_registartion(parent, arg_family_type_struct.validation_date)
					insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6038, result) #WorkParticipation: 6038
				end
	         else
				# if arg_family_type_struct.service_program_id == 1 || arg_family_type_struct.validation_level == "APP"
				# 	result = ClientCharacteristic.has_valid_minor_parent_work_registartion_without_date(parent)
				# 	insert_application_eligibility_result(arg_family_type_struct.application_id, parent, 6038, result)
				# end
			end
		end
	end


	def insert_application_eligibility_result(arg_application_id, arg_client_id, arg_data_item_type, arg_result)
		ins_application_eligibility_results = ApplicationEligibilityResults.new
		ins_application_eligibility_results.application_id = arg_application_id
		ins_application_eligibility_results.client_id = arg_client_id
		ins_application_eligibility_results.data_item_type = arg_data_item_type
		ins_application_eligibility_results.result = arg_result
		ins_application_eligibility_results.save
	end

	def validate_residence_address(arg_family_type_struct, primary_member)
		result = true
		is_primary_member_address_inserted = false
		primary_member_address = Address.get_non_mailing_address(primary_member.client_id, 6150)#ClientAddress.get_residence_address(primary_member.client_id)

		if primary_member_address.present?
			# unless is_primary_member_address_inserted
			# 	insert_application_eligibility_result(arg_family_type_struct.application_id, primary_member.client_id, 6087, result) #Living Arrangement
			# 	is_primary_member_address_inserted = true
			# end
			arg_family_type_struct.members_list.each do |client|
				if primary_member.client_id != client.client_id
					client_address = Address.get_non_mailing_address(client.client_id, 6150)#ClientAddress.get_residence_address(client.client_id)
					if client_address.present?
						primary_member_address_compare = primary_member_address.first
						client_address = client_address.first
						result = compare_address_for_the_clients(primary_member_address_compare, client_address)
					else
						result = false
					end
					insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6087, result) #Living Arrangement
				end
			end
		else
			result = false
			insert_application_eligibility_result(arg_family_type_struct.application_id, primary_member.client_id, 6087, result) #Living Arrangement
		end
	end

	def compare_address_for_the_clients(arg_primary_address, arg_client_address)
		result = true
		if arg_primary_address.address_line1.downcase != arg_client_address.address_line1.downcase ||
			arg_primary_address.city.downcase != arg_client_address.city.downcase ||
			arg_primary_address.state  != arg_client_address.state ||
			arg_primary_address.zip  != arg_client_address.zip
			result = false
		end
		if arg_primary_address.address_line2.present? && !(arg_client_address.address_line2.present?) ||
			!(arg_primary_address.address_line2.present?) && arg_client_address.address_line2.present?
			result = false
		else
			if arg_primary_address.address_line2.present? && arg_client_address.address_line2.present? && (arg_primary_address.address_line2.downcase != arg_client_address.address_line2.downcase)
				result = false
			end
		end
		return result
	end

	def validate_state_residence(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			result = Client.is_a_state_resident(client.client_id)
			insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6088, result) # State Residence
		end
	end

	def validate_citizenship_information(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			result = Alien.is_a_citizen_or_eligible_alien(client.client_id)
			insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6089, result) #"Citizenship or Eligible Alien  requirement is not met"
		end
	end

	def validate_employment_information(arg_family_type_struct)
		# valid employment should be present at program unit level
		if  arg_family_type_struct.validation_level == "PU"
			client_id_employment = []
			client_id_no_employment = []
			if (arg_family_type_struct.service_program_id == 3 )
				employment = false
				arg_family_type_struct.parents_list.each do |parent|
					employment_present = EmploymentDetail.valid_employment_should_be_present(parent)#valid employment and employment details
					if employment_present == true
					   client_id_employment << parent
					   employment = true
					else
						client_id_no_employment << parent
						employment = false
					end
	               break if employment == true
	     		end
	     	elsif (arg_family_type_struct.service_program_id == 4)
	           	employment = false
	           	case arg_family_type_struct.case_type_integer
				when 6046
					arg_family_type_struct.adult_list.each do |parent|
						employment_hours = EmploymentDetail.get_active_employment_for_client(parent, arg_family_type_struct.run_month)
						if employment_hours.present?
							if employment_hours >= 24
							   client_id_employment << parent
				           	   employment = true
				           	else
				           	   client_id_no_employment << parent
				           	   employment = false
				            end
						end
				    end

				when 6047
					paid_work_hours_for_adults = 0
						arg_family_type_struct.adult_list.each do |parent|
							employment_hours = EmploymentDetail.get_active_employment_for_client(parent, arg_family_type_struct.run_month)
							if employment_hours.present?
			                   paid_work_hours_for_adults = paid_work_hours_for_adults + employment_hours
			                end
			            end
			            if paid_work_hours_for_adults.present?
							if paid_work_hours_for_adults >= 24
							   client_id_employment << parent
				           	   employment = true
				           	else
				           	   client_id_no_employment << parent
				           	   employment = false
				            end
						end
				end
	        end

			if employment == true
	           client_id_employment.each do |emp_present_parents|
	           	insert_application_eligibility_result(arg_family_type_struct.application_id, emp_present_parents, 6570, true)
	           end

			else
				client_id_no_employment.each do |no_emp_present_parents|
			    insert_application_eligibility_result(arg_family_type_struct.application_id, no_emp_present_parents, 6570, false)
			    end
			end

	    end
	end


	def eligibility_rules_for_application(arg_family_type_struct)
		primary_contact = PrimaryContact.get_primary_contact(arg_family_type_struct.application_id, 6587)
		validate_residence_address(arg_family_type_struct, primary_contact) if primary_contact.present?
	end

	def eligibility_rules_for_program_unit(arg_family_type_struct)
		primary_contact = PrimaryContact.get_primary_contact(arg_family_type_struct.program_unit_id, 6345)
		validate_residence_address(arg_family_type_struct, primary_contact) if primary_contact.present?
	end

	def eligibility_rules_for_program_wizard(arg_family_type_struct)
		primary_contact = PrimaryContact.get_primary_contact(arg_family_type_struct.program_unit_id, 6345)
		validate_residence_address(arg_family_type_struct, primary_contact) if primary_contact.present?
	end

	def validate_for_ssi_income_or_ssi_characteristics(arg_family_type_struct)
		arg_family_type_struct.adult_list.each do |adult|
			if ProgramBenefitMember.check_if_client_has_valid_status_for_ssi_validation(adult, arg_family_type_struct.program_wizard_id)
				result = !(Income.is_the_client_recieving_ssi(adult, arg_family_type_struct.run_month) || ClientCharacteristic.has_disability_ssi_characteristic(adult, arg_family_type_struct.run_month))
				insert_application_eligibility_result(arg_family_type_struct.application_id, adult, 6329, result) # Receiving SSI
			end
		end
	end

	def validate_dob_information(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			result = Client.has_dob(client.client_id)
			insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6751, result) # "Date of Birth requirement"
		end
	end

	def validate_felon_characteristic(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			if Client.has_felon_characteristics(client.client_id)
				result = ClientCharacteristic.has_felon_characteristic(client.client_id)
				insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6752, result) # "Felon characteristic is req"
			end
		end
	end

	def validate_tea_out_of_state_payments(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			if Client.has_received_any_tea_out_of_state_payments(client.client_id)
				result = OutOfStatePayment.are_there_any_out_of_state_pymts_for_the_client(client.client_id)
				insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6753, result) # "Outs of state payments"
			end
		end
	end

	# @completed_steps = HouseholdMemberStepStatus.get_steps_completed_for_client(client_object.id, arg_member.household_id)
	# @all_steps = HouseholdMemberStepStatus.get_all_steps_for_client(client_object.id,arg_member.household_id)

	def validate_household_registration_completion(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			result = HouseholdMemberStepStatus.is_household_registration_complete_for_the_client(client.client_id, arg_family_type_struct.household_id)
			insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6750, result) # "Household Registration"
		end
	end

	def validate_race_information(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			result = ClientRace.has_race(client.client_id)
			insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6754, result) # "Household Registration"
		end
	end

	def validate_physical_address_information(arg_family_type_struct)
		arg_family_type_struct.members_list.each do |client|
			result = Address.is_physical_address_verified_for_the_client(client.client_id)
			insert_application_eligibility_result(arg_family_type_struct.application_id, client.client_id, 6765, result) # "Physical Address not verified"
			# break
		end
	end
end