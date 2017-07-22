class ProgramEligibilityService

	def self.check_program_eligibility(arg_service_program_id, arg_client_id)
		result = ""
		case arg_service_program_id
			when 1
				result = check_tea_program_eligibility(arg_service_program_id, arg_client_id)
			when 2
				result = check_tea_relocation_eligibility(arg_service_program_id, arg_client_id)
			when 3

				result = check_for_tea_diversion_eligibility(arg_service_program_id, arg_client_id)
			when 4

				result = check_work_pays_eligibility(arg_service_program_id, arg_client_id)
			when 5
				result = check_wise_eligibility(arg_service_program_id, arg_client_id)
		end
		return result
	end

	def self.check_tea_program_eligibility(arg_service_program_id, arg_client_id)
		result = ""

		result = check_if_the_client_is_already_enrolled_in_a_tea_program(arg_service_program_id, arg_client_id) #Client is open in a TEA program

		result = (result == "Potentially Eligible" ? check_for_tea_diversion_within_hundred_days(arg_client_id) : result) #Client is receiving TEA Diversion payments

		result = (result == "Potentially Eligible" ? check_for_federal_time_limits(arg_client_id) : result)

		result = (result == "Potentially Eligible" ? check_for_tea_state_count(arg_client_id) : result)
		# Check for previous program

		# if ProgramUnitMember.check_open_status_for_a_program(arg_client_id, arg_service_program_id)
		# 	result = "Client is already enrolled in a TEA Program"
		# else
		# 	# Check for time limits
		# 	time_limit_collection = TimeLimit.get_federal_count(arg_client_id)
		# 	if time_limit_collection.present?

		# 		if time_limit_collection.first.federal_count < SystemParam.get_federal_limits_count()
		# 			if time_limit_collection.first.tea_state_count < SystemParam.get_state_limits_count()
		# 				result = check_for_tea_diversion_within_hundred_days(arg_client_id)
		# 			else
		# 				result = "Client has reached State TimeLimit of #{SystemParam.get_state_limits_count()} months"
		# 			end
		# 		else
		# 			result = "Client has reached Federal TimeLimit of #{SystemParam.get_federal_limits_count()} months"
		# 		end
		# 	else
		# 		# record not found in timelimit table
		# 		result = check_for_tea_diversion_within_hundred_days(arg_client_id)
		# 	end
		# end
		return result
	end

	def self.check_for_tea_diversion_within_hundred_days(arg_client_id)
		if Client.is_adult(arg_client_id)
			if InStatePayment.is_there_a_diversion_payment_with_in_hundred_days(arg_client_id)
				return "Client has received a diversion payment within last 100 days"
			else
				return "Potentially Eligible"
			end
		else
			return "Potentially Eligible"
		end
	end

	def self.check_tea_relocation_eligibility(arg_service_program_id, arg_client_id)

	end
	def self.check_for_tea_diversion_eligibility(arg_service_program_id, arg_client_id)
		result = check_diversion_eligibility(arg_service_program_id, arg_client_id)
		result = (result == "Potentially Eligible" ? check_for_federal_time_limits(arg_client_id) : result)
		result = (result == "Potentially Eligible" ? check_for_tea_state_count(arg_client_id) : result)
	return result
	end


	def self.check_diversion_eligibility(arg_service_program_id, arg_client_id)
		if InStatePayment.check_for_diversion_payments(arg_client_id)
			return "Client has already received a diversion payment"
		else
			return "Potentially Eligible"
		end
	end

	def self.check_work_pays_eligibility(arg_service_program_id, arg_client_id)
		# Check for previous program

		result = check_if_the_client_is_already_enrolled_in_a_work_pays_program(arg_service_program_id, arg_client_id)# Client is already open in a Work Pays program

		result = (result == "Potentially Eligible" ? check_for_tea_case_closed_with_in_last_six_months(arg_client_id) : result)#Client does not have a closed tea case within last six months

		result = (result == "Potentially Eligible" ? check_if_client_has_received_a_minimum_of_three_tea_payments(arg_client_id) : result)# Client has not received a minimum of three TEA payments

		result = (result == "Potentially Eligible" ? check_for_federal_time_limits(arg_client_id) : result)

		result = (result == "Potentially Eligible" ? check_for_work_pays_state_count(arg_client_id) : result)# Work Pays State Time Limits

		return result
	end

	def self.check_wise_eligibility(arg_service_program_id, arg_client_id)

	end

	def self.check_if_the_client_is_already_enrolled_in_a_tea_program(arg_service_program_id, arg_client_id)
		result = ""
		if ProgramUnitMember.check_open_status_for_a_program(arg_client_id, arg_service_program_id)
			result = "Client is already enrolled in a TEA Program"
		else
			result = "Potentially Eligible"
		end
		return result
	end

	def self.check_if_the_client_is_already_enrolled_in_a_work_pays_program(arg_service_program_id, arg_client_id)
		result = ""
		if ProgramUnitMember.check_open_status_for_a_program(arg_client_id, arg_service_program_id)
			result = "Client is already enrolled in a Work Pays Program"
		else
			result = "Potentially Eligible"
		end
		return result
	end

	def self.check_for_tea_case_closed_with_in_last_six_months(arg_client_id)
		result = ""
		if ProgramUnitMember.check_for_closed_tea_case_with_in_last_six_months(arg_client_id)
			result = "Potentially Eligible"
		else
			result = "Client does not have TEA program closed within last 6 months"
		end
		Rails.logger.debug("check_for_tea_case_closed_with_in_last_six_months.result = #{result}")
		return result
	end

	def self.check_if_client_has_received_a_minimum_of_three_tea_payments(arg_client_id)
		result = ""
		if InStatePayment.did_the_client_receive_atleast_three_tea_payments(arg_client_id)
			result = "Potentially Eligible"
		else
			result = "Client did not receive a minimum of 3 TEA payments"
		end
		return result
	end

	def self.check_for_federal_time_limits(arg_client_id)
		result = ""
		time_limit_collection = TimeLimit.get_federal_count(arg_client_id)
		if time_limit_collection.present?
			if time_limit_collection.first.federal_count < SystemParam.get_federal_limits_count()
				result = "Potentially Eligible"
			else
				result = "Client has reached Federal TimeLimit of #{SystemParam.get_federal_limits_count()} months"
			end
		else
			# record not found in timelimit table
			result = "Potentially Eligible"
		end
		return result
	end

	def self.check_for_work_pays_state_count(arg_client_id)
		result = ""
		time_limit_collection = TimeLimit.get_federal_count(arg_client_id)
		if time_limit_collection.present?
			if time_limit_collection.first.work_pays_state_count.present?
			 	if time_limit_collection.first.work_pays_state_count < SystemParam.get_state_limits_count()
					result = "Potentially Eligible"
				else
					result = "Client has reached State TimeLimit of #{SystemParam.get_state_limits_count()} months"
				end
			else
			 	result = "Potentially Eligible"
			end
		else
			result = "Potentially Eligible"
		end
		return result



		# if !(time_limit_collection.present?) || time_limit_collection.first.work_pays_state_count < SystemParam.get_state_limits_count()
		# 	result = "Eligible"
		# else
		# 	result = "Client has reached State TimeLimit of #{SystemParam.get_state_limits_count()} months"
		# end

	end

	def self.check_for_tea_state_count(arg_client_id)
		result = ""
		time_limit_collection = TimeLimit.get_federal_count(arg_client_id)
		if time_limit_collection.present?
			if time_limit_collection.first.tea_state_count.present?
				if time_limit_collection.first.tea_state_count < SystemParam.get_state_limits_count()
					result = "Potentially Eligible"
				else
					result = "Client has reached State TimeLimit of #{SystemParam.get_state_limits_count()} months"
				end
			else
				result = "Potentially Eligible"
			end
		else
			result = "Potentially Eligible"
		end
		return result


		# if !(time_limit_collection.present?) || time_limit_collection.first.tea_state_count < SystemParam.get_state_limits_count()
		# 	result = "Eligible"
		# else
		# 	result = "Client has reached State TimeLimit of #{SystemParam.get_state_limits_count()} months"
		# end

	end

	def self.check_wheather_client_has_three_months_sanctions_for_six_months_of_workpays(arg_client_id)
		result = ""
		sanctions = Sanction.did_the_client_receive_sanction_payments_for_work_pays_in_last_6_months(arg_client_id)
		if sanctions == true
		result = "client ( #{Client.get_client_full_name_from_client_id(arg_client_id)}) has recived three month of sanction payment in last six months"
		else
		result = "Potentially Eligible"

		end
	  return result
	end


	def self.check_for_valid_employment_for_the_client(arg_client_id)
		result = ""
		employment =  EmploymentDetail.valid_employment_should_be_present(arg_client_id)
		if employment == false
		   result = "client ( #{Client.get_client_full_name_from_client_id(arg_client_id)}) does not have valid employment"
		else
		   result = "Potentially Eligible"
		end
	  return result

	end

end