class ApplicationDataValidationService
	# Kiran Chamarthi 09/18/2014
	def validate(arg_application_id)
		clients = ApplicationMember.get_clients_list_for_the_application(arg_application_id)
		clients.each do |client|
			DataValidation.delete_client_information(client.client_id)
			is_ssn_present(client.client_id)
			is_residency_present(client.client_id)
			is_dob_present(client.client_id)
			is_address_present(client.client_id)
			# is_work_registration_present(client.client_id)
		end

	end

	def is_ssn_present(arg_client_id)
		insert_data_validation(arg_client_id, 6030, Client.has_ssn(arg_client_id)) # SSN
	end

	def is_residency_present(arg_client_id)
		insert_data_validation(arg_client_id, 6031, Client.is_a_state_resident(arg_client_id)) # "RESIDENCY"
	end

	def is_dob_present(arg_client_id)
		insert_data_validation(arg_client_id, 6032, Client.has_dob(arg_client_id)) #"DOB"
	end

	def is_address_present(arg_client_id)
		if ApplicationMember.is_primary_member(arg_client_id)
			insert_data_validation(arg_client_id, 6033, Address.has_address(arg_client_id)) #"ADDRESS"
		end
	end

	# def is_work_registration_present(arg_client_id)
	#     if Client.is_adult(arg_client_id)
	#     	insert_data_validation(arg_client_id, 6034, ClientCharacteristic.has_work_registartion(arg_client_id)) #"WORK REGISTRATION"
	# 	end
	# end


	# def is_education_present(arg_client_id)
	#     insert_data_validation(arg_client_id, 6051, Education.is_there_an_education_associated(arg_client_id))
	# end

	# def validate_other_characteristic(arg_client_id)
	# 	result = ClientCharacteristic.has_valid_other_characteristic(arg_client_id)
	# 	unless result
	# 		insert_data_validation(arg_client_id, CodetableItem.get_short_description(6078), result)
	# 	end
	# end

	def insert_data_validation(arg_client_id, arg_data_item_type, arg_result)
		ins_validation_data = DataValidation.new
		ins_validation_data.client_id = arg_client_id
		ins_validation_data.data_item_type = arg_data_item_type
		ins_validation_data.result = arg_result
		ins_validation_data.save
	end

	# Manoj Patil
	# 09/27/2014
	# Data Validation for Program Unit Members.
	def validate_program_unit_members_data_elements(arg_program_unit_id)
		program_unit_members = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)
		program_unit_members.each do |member|
			DataValidation.delete_client_information(member.client_id)
			is_ssn_present(member.client_id)
			is_residency_present(member.client_id)
			is_dob_present(member.client_id)
			is_address_present(member.client_id)
			# is_work_registration_present(member.client_id)
		end
	end

	def assessment_validations(arg_client_id, arg_program_unit_id, arg_assessment_id)
		DataValidation.delete_assessment_validation_information(arg_client_id)
		is_learning_difficulty_screening_present(arg_client_id)
		if arg_program_unit_id.present? && arg_program_unit_id != 0
			program_unit = ProgramUnit.find_by_id(arg_program_unit_id)
			is_career_interest_present(arg_client_id, arg_assessment_id) if program_unit.present? && [6046,6047].include?(program_unit.case_type)
		end
	end

	def is_learning_difficulty_screening_present(arg_client_id)
		insert_data_validation(arg_client_id, 6775, ClientScore.check_if_LD_scores_are_present(arg_client_id) == "SUCCESS") # "Learning Difficulty Screening is required"
	end

	def is_career_interest_present(arg_client_id, arg_assessment_id)
		insert_data_validation(arg_client_id, 6776, AssessmentCareer.get_assessment_career(arg_client_id, arg_assessment_id).present?) # "Career Interests is required"
	end
end