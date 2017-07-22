# Author  Kiran
# Modifications
# Manoj 09/29/2014
# Added determine_program_unit_eligibilty

class ApplicationEligibilityServiceScreeningOnly

	# def determine_application_eligibilty
	# 	# variables intitialized to distinguish the level of validation - Kiran 03/25/2015
	# 	@family_struct.validation_level  = "APP"
	# 	@family_struct.validation_date = @family_struct.application_date

	# 	#Delete all the existing application eligibility results for clients associated with the application
	# 	ApplicationEligibilityResults.delete_results_for_the_application(@family_struct.application_id)
	# 	# To invoke common eleigibility rules across application, program unit and program wizard eligibility determination
	# 	run_eligibility

	# 	# Eligibility rules for application level ed. All the rules specific to application alone should go in this method.
	# 	eligibility_rules_for_application
	# end

	# def determine_program_unit_eligibilty
	# 	# variables intitialized to distinguish the level of validation - Kiran 03/25/2015
	# 	@family_struct.validation_level  = "PU"
	# 	@family_struct.validation_date = @family_struct.application_date

	# 	l_program_unit_object = ProgramUnit.find(@family_struct.program_unit_id)
	# 	@family_struct.application_id = l_program_unit_object.client_application_id
	# 	#Delete all the existing application eligibility results for clients associated with the program unit
	# 	clients = ProgramUnit.get_clients_list_from_program_unit_id(@family_struct.program_unit_id)
	# 	clients.each do |client|
	# 		ApplicationEligibilityResults.delete_results_based_on_application_id_and_client_id(@family_struct.application_id, client.client_id)
	# 	end
	# 	# To invoke common eleigibility rules across application, program unit and program wizard eligibility determination
	# 	run_eligibility

	# 	eligibility_rules_for_program_unit
	# end

	def determine_program_wizard_eligibilty(arg_family_struct)
		# variables intitialized to distinguish the level of validation - Kiran 03/25/2015
		@family_struct = arg_family_struct

		@family_struct.validation_level  = "ED"

		# @family_struct.validation_date = @family_struct.run_month

		# @family_struct.application_id = ProgramWizard.get_application_id_from_program_wizard_id(@family_struct.program_wizard_id)

		#Delete all the existing application eligibility results for clients associated with the program wizard

		# clients = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(@family_struct.program_wizard_id)
		# clients.each do |client|
		# 	ApplicationEligibilityResults.delete_results_based_on_application_id_and_client_id(@family_struct.application_id, client.client_id)
		# end

		#ApplicationEligibilityResults.delete_results_for_the_application(@family_struct.application_id)
		# To invoke common eleigibility rules across application, program unit and program wizard eligibility determination
		run_eligibility

		# eligibility_rules_for_program_wizard

		# Not needed because the navigator is performing this check whereas when a new program creation is occured on Navigator page this validation should fire appropriately
		# validate_for_ssi_income_or_ssi_characteristics
		return @family_struct
	end

	def run_eligibility
		# In case of minor parent case or single parent case without a spouse relation, check for deprivation code for the kid
		# check_for_kid_deprivation_if_it_is_a_minor_parent_or_single_parent_case
		# Check deprivation code for all children in the program except for the minor parent
		# check_deprivation_code_for_children_in_the_program

		if @family_struct.validation_level  == "APP"
			# Need to revisit
			if @family_struct.case_type != 6048
				# Not equal to child only case
				validate_work_participation_characteristics
			end
			#TEA diversion does not need warning messages for child education or immunization
			validate_immunization_for_children
		    validate_education_for_children

		else
			if @family_struct.service_program_id != 3 # Not TEA Diversion program
				if @family_struct.case_type != 6048 # Not equal to child only case

					# Commented to skip the work participation validation at the navigator page

					# validate_work_participation_characteristics
				end
				#TEA diversion does not need warning messages for child education or immunization
				validate_immunization_for_children
		        validate_education_for_children

			end
		end
		# Check Felony and Parole characterisctics for all the adults within the application, if other characteristics exits
		# Not needed because the navigator is performing this check whereas when a new program creation is occured on Navigator page this validation should fire appropriately
		# validate_other_characteristics
		# Check resident status for all the members
		validate_state_residence
		# Check citizenship information for all the members
		validate_citizenship_information

		# validate_employment_information

	end

	def validate_work_participation_characteristics
		# If it's a 2 parent case, check for work particiapation for both the parents instead of checking it for all the adults
		case @family_struct.case_type
		when 6047,6046
			# 6047 - Two parent case
			# 6046 - "Single Parent Case"
			validate_presence_of_work_participation_for_parents
		when 6049
			#"Minor Parent Case"
			validate_work_participation_characteristics_for_minor_parents
		end

	end

	def validate_presence_of_work_participation_for_parents
		@family_struct.adults_struct.each do |parent|
			result = ""
			if @family_struct.validation_level == "ED"
				if @family_struct.service_program_id == 1
					if Client.is_adult(parent.parent_id)
						result = ClientCharacteristic.has_work_registartion(parent.parent_id, @family_struct.validation_date)
						unless result
							# parent.ineligible_codes << 6038
							@family_struct.ineligible_codes[parent.parent_id] << 6038
						end
						# insert_application_eligibility_result(@family_struct.application_id, parent, 6038, result) #WorkParticipation: 6038
					end
				elsif @family_struct.service_program_id == 4 # The rule is applicable only for work pays and not for TEA Diversion by any chance
					if @family_struct.case_type == 6047
						validate_work_charateristics_for_two_parent_case_for_work_pays
					else
                      result = ClientCharacteristic.open_mandatory_work_characteristic_found?(parent.parent_id, @family_struct.validation_date)
                      unless result
                      	@family_struct.ineligible_codes[parent.parent_id] << 6337
                      end
                      # insert_application_eligibility_result(@family_struct.application_id, parent, 6337, result) #Mandatory Work Participation requirement
					end
				end
	         else
	         	# Need to revisit
				# if @family_struct.service_program_id == 1 || @family_struct.validation_level == "APP"
				# 	characteritics_object = ClientCharacteristic.get_all_work_characteristic_records_for_the_client(parent).count > 0
				# 	result = "#{characteritics_object}"
				# 	insert_application_eligibility_result(@family_struct.application_id, parent, 6038, result) #WorkParticipation: 6038
				# else

				# 	if @family_struct.service_program_id == 4 # The rule is applicable only for work pays and not for TEA Diversion by any chance
				# 		characteritics_object = ClientCharacteristic.get_all_work_characteristic_records_for_the_client(parent).count > 0
				# 		result = "#{characteritics_object}"
				# 		insert_application_eligibility_result(@family_struct.application_id, parent, 6038, result) #Mandatory Work Participation requirement
				# 	end
				# end
			end
		end
	end

	def validate_work_charateristics_for_two_parent_case_for_work_pays
		mandatory_characteristics_present = false
		@family_struct.adults_struct.each do |parent|
			if Client.is_adult(parent.parent_id)
				mandatory_characteristics_present ||= ClientCharacteristic.open_mandatory_work_characteristic_found?(parent.parent_id, @family_struct.validation_date)
				work_charaterstics = ClientCharacteristic.has_work_registartion(parent.parent_id, @family_struct.validation_date)
				unless work_charaterstics
					# parent.ineligible_codes << 6038
					@family_struct.ineligible_codes[parent.parent_id] << 6038
				end
			end
		end
		unless mandatory_characteristics_present
			@family_struct.adults_struct.each do |parent|
				# parent.ineligible_codes << 6337
				@family_struct.ineligible_codes[parent.parent_id] << 6337
				break
			end
		end
	end




	def validate_other_characteristics
		# Check for other characteristics violations only for all program members
		@family_struct.members.each do |client_id|
			check_for_violations(client_id)
		end
	end

	def check_for_violations(arg_client_id)
		result = ClientCharacteristic.has_valid_other_characteristic(arg_client_id, @family_struct.validation_date)
		unless result
			@family_struct.ineligible_codes[arg_client_id] << 6085
		end
		# insert_application_eligibility_result(@family_struct.application_id, arg_client_id, 6085, result)
	end

	def validate_immunization_for_children
		# All children below 5 years should have an immunization record
		@family_struct.members.each do |client_id|
			age = Client.get_age(client_id)
			if age < 5
				result = Client.is_exempted_from_immunization(client_id) || ClientImmunization.is_there_an_immunization_associated(client_id)
				# Uncomment the code below if you want to consider immunization as critical
				# unless result
				# 	@family_struct.ineligible_codes[client_id] << 6035
				# end
			end
		end
	end

	def validate_education_for_children
		# All children greater than equal to 5 years should have education asscoiation
		@family_struct.members.each do |client_id|
			age = Client.get_age(client_id)
			if age > 5 && Client.is_child(client_id)
				# Uncomment the code below if you want to consider education as critical
				# unless Education.is_there_an_education_associated(client_id)
				# 	@family_struct.ineligible_codes[client_id] << 6036
				# end
			end
		end
	end

	# def check_for_kid_deprivation_if_it_is_a_minor_parent_or_single_parent_case
	# 	if @family_struct.family_type == 1
	# 		# In case of minor parent case or single parent case without a spouse relation, check for deprivation code for the kid
	# 		if @family_struct.parents_list.count == 1
	# 			if ( (@family_struct.minor_parent_case.present? && @family_struct.minor_parent_case) ||
	# 					!ClientRelationship.is_there_a_spouse_relation_for_the_client(@family_struct.parents_list[0]) )
	# 				result = ClientParentalRspability.is_there_a_deprivation_code_associated(@family_struct.child)
	# 				insert_application_eligibility_result(@family_struct.application_id, @family_struct.child, 6037, result) #Deprivation: 6037
	# 			else
	# 				# This is a single parent case with a care taker, check if there is work participation for all the adults in the application
	# 				# @family_struct.adult_list.each do |adult|
	# 				# 	result = ClientCharacteristic.has_work_registartion(adult, @family_struct.run_month)
	# 				# 	insert_application_eligibility_result(@family_struct.application_id, adult, 6038, result) #WorkParticipation: 6038
	# 				# end
	# 			end
	# 		end
	# 	end
	# end

	# def check_deprivation_code_for_children_in_the_program
	# 	# Rails.logger.debug("@family_struct.child_list = #{@family_struct.child_list}")
	# 	@family_struct.child_list.each do |child|
	# 		# Rails.logger.debug("ClientRelationship.is_there_a_parent_relationship(child) = #{ClientRelationship.is_there_a_parent_relationship(child)}")
	# 		unless ClientRelationship.is_there_a_parent_relationship(child)
	# 			result = ClientParentalRspability.is_there_a_deprivation_code_associated(child)
	# 			insert_application_eligibility_result(@family_struct.application_id, child, 6037, result) #Deprivation: 6037
	# 		end
	# 	end
	# end

	def validate_work_participation_characteristics_for_minor_parents
		# Eligibility determination should handle if a work participation for the given month is provided or not.
		@family_struct.adults_struct.each do |parent|
			result = ""
			if @family_struct.validation_level == "ED"
				if @family_struct.service_program_id == 1
					unless ClientCharacteristic.has_valid_minor_parent_work_registartion(parent.parent_id, @family_struct.validation_date)
						# insert_application_eligibility_result(@family_struct.application_id, parent.parent_id, 6038, result) #WorkParticipation: 6038
						@family_struct.ineligible_codes[parent.parent_id] << 6038
					end
				end
	         else
	         	# Needs a revisit
				if @family_struct.service_program_id == 1 || @family_struct.validation_level == "APP"
					result = ClientCharacteristic.has_valid_minor_parent_work_registartion_without_date(parent.parent_id)
					insert_application_eligibility_result(@family_struct.application_id, parent.parent_id, 6038, result)
				end
			end
		end
	end


	# def insert_application_eligibility_result(arg_application_id, arg_client_id, arg_data_item_type, arg_result)
	# 	ins_application_eligibility_results = ApplicationEligibilityResults.new
	# 	ins_application_eligibility_results.application_id = arg_application_id
	# 	ins_application_eligibility_results.client_id = arg_client_id
	# 	ins_application_eligibility_results.data_item_type = arg_data_item_type
	# 	ins_application_eligibility_results.result = arg_result
	# 	ins_application_eligibility_results.save
	# end

	# def validate_residence_address(@family_struct, primary_member)
	# 	result = true
	# 	is_primary_member_address_inserted = false
	# 	primary_member_address = Address.get_non_mailing_address(primary_member.client_id, 6150)#ClientAddress.get_residence_address(primary_member.client_id)

	# 	if primary_member_address.present?
	# 		# unless is_primary_member_address_inserted
	# 		# 	insert_application_eligibility_result(@family_struct.application_id, primary_member.client_id, 6087, result) #Living Arrangement
	# 		# 	is_primary_member_address_inserted = true
	# 		# end
	# 		@family_struct.members_list.each do |client|
	# 			if primary_member.client_id != client.client_id
	# 				client_address = Address.get_non_mailing_address(client.client_id, 6150)#ClientAddress.get_residence_address(client.client_id)
	# 				if client_address.present?
	# 					primary_member_address_compare = primary_member_address.first
	# 					client_address = client_address.first
	# 					result = compare_address_for_the_clients(primary_member_address_compare, client_address)
	# 				else
	# 					result = false
	# 				end
	# 				insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6087, result) #Living Arrangement
	# 			end
	# 		end
	# 	else
	# 		result = false
	# 		insert_application_eligibility_result(@family_struct.application_id, primary_member.client_id, 6087, result) #Living Arrangement
	# 	end
	# end

	# def compare_address_for_the_clients(arg_primary_address, arg_client_address)
	# 	result = true
	# 	if arg_primary_address.address_line1.downcase != arg_client_address.address_line1.downcase ||
	# 		arg_primary_address.city.downcase != arg_client_address.city.downcase ||
	# 		arg_primary_address.state  != arg_client_address.state ||
	# 		arg_primary_address.zip  != arg_client_address.zip
	# 		result = false
	# 	end
	# 	if arg_primary_address.address_line2.present? && !(arg_client_address.address_line2.present?) ||
	# 		!(arg_primary_address.address_line2.present?) && arg_client_address.address_line2.present?
	# 		result = false
	# 	else
	# 		if arg_primary_address.address_line2.present? && arg_client_address.address_line2.present? && (arg_primary_address.address_line2.downcase != arg_client_address.address_line2.downcase)
	# 			result = false
	# 		end
	# 	end
	# 	return result
	# end

	def validate_state_residence
		@family_struct.members.each do |client_id|
			unless Client.is_a_state_resident(client_id)
				@family_struct.ineligible_codes[client_id] << 6088
			end
			# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6088, result) # State Residence
		end
	end

	def validate_citizenship_information
		@family_struct.members.each do |client_id|
			unless Alien.is_a_citizen_or_eligible_alien(client_id)
				@family_struct.ineligible_codes[client_id] << 6089
			end
			# insert_application_eligibility_result(@family_struct.application_id, client.client_id, 6089, result) #"Citizenship or Eligible Alien  requirement is not met"
		end
	end

	# def validate_employment_information
	# 	# valid employment should be present at program unit level
	# 	if  @family_struct.validation_level == "PU"
	# 		client_id_employment = []
	# 		client_id_no_employment = []
	# 		if (@family_struct.service_program_id == 3 )
	# 			employment = false
	# 			@family_struct.parents_list.each do |parent|
	# 				employment_present = EmploymentDetail.valid_employment_should_be_present(parent)#valid employment and employment details
	# 				if employment_present == true
	# 				   client_id_employment << parent
	# 				   employment = true
	# 				else
	# 					client_id_no_employment << parent
	# 					employment = false
	# 				end
	#                break if employment == true
	#      		end
	#      	elsif (@family_struct.service_program_id == 4)
	#            	employment = false
	#            	case @family_struct.case_type
	# 			when 6046
	# 				@family_struct.adult_list.each do |parent|
	# 					employment_hours = EmploymentDetail.get_active_employment_for_client(parent, @family_struct.run_month)
	# 					if employment_hours.present?
	# 						if employment_hours >= 24
	# 						   client_id_employment << parent
	# 			           	   employment = true
	# 			           	else
	# 			           	   client_id_no_employment << parent
	# 			           	   employment = false
	# 			            end
	# 					end
	# 			    end

	# 			when 6047
	# 				paid_work_hours_for_adults = 0
	# 					@family_struct.adult_list.each do |parent|
	# 						employment_hours = EmploymentDetail.get_active_employment_for_client(parent, @family_struct.run_month)
	# 						if employment_hours.present?
	# 		                   paid_work_hours_for_adults = paid_work_hours_for_adults + employment_hours
	# 		                end
	# 		            end
	# 		            if paid_work_hours_for_adults.present?
	# 						if paid_work_hours_for_adults >= 24
	# 						   client_id_employment << parent
	# 			           	   employment = true
	# 			           	else
	# 			           	   client_id_no_employment << parent
	# 			           	   employment = false
	# 			            end
	# 					end
	# 			end
	#         end

	# 		if employment == true
	#            client_id_employment.each do |emp_present_parents|
	#            	insert_application_eligibility_result(@family_struct.application_id, emp_present_parents, 6570, true)
	#            end

	# 		else
	# 			client_id_no_employment.each do |no_emp_present_parents|
	# 		    insert_application_eligibility_result(@family_struct.application_id, no_emp_present_parents, 6570, false)
	# 		    end
	# 		end
	#     end
	# end


	# def eligibility_rules_for_application
	# 	primary_member = ApplicationMember.get_primary_applicant(@family_struct.application_id)
	# 	if primary_member.present?
	# 		primary_member = primary_member.first
	# 		validate_residence_address(@family_struct, primary_member)
	# 	end
	# end

	# def eligibility_rules_for_program_unit
	# 	# primary_member = ProgramUnitMember.get_primary_beneficiary(@family_struct.program_unit_id)
	# 	primary_contact = PrimaryContact.get_primary_contact(@family_struct.program_unit_id, 6345)
	# 	if primary_contact.present?
	# 		validate_residence_address(@family_struct, primary_contact)
	# 	end
	# end

	# def eligibility_rules_for_program_wizard
	# 	# primary_member = ProgramUnitMember.get_primary_beneficiary(@family_struct.program_unit_id)
	# 	primary_contact = PrimaryContact.get_primary_contact(@family_struct.program_unit_id, 6345)
	# 	if primary_contact.present?
	# 		validate_residence_address(@family_struct, primary_contact)
	# 	end
	# end

	def validate_for_ssi_income_or_ssi_characteristics
		@family_struct.adults_struct.each do |parent|
			if Client.is_adult(parent.parent_id) && (parent.status == 4468 || parent.status == 4469)
				result = !(Income.is_the_client_recieving_ssi(parent.parent_id, @family_struct.validation_date) || ClientCharacteristic.has_disability_ssi_characteristic(parent.parent_id, @family_struct.validation_date))
				if Income.is_the_client_recieving_ssi(parent.parent_id, @family_struct.validation_date) || ClientCharacteristic.has_disability_ssi_characteristic(parent.parent_id, @family_struct.validation_date)
					@family_struct.ineligible_codes[parent.parent_id] << 6329
				end
				# insert_application_eligibility_result(@family_struct.application_id, adult, 6329, result) # Receiving SSI
			end
		end
	end

end