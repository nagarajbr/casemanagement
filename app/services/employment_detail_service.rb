class EmploymentDetailService
	def self.save_employment_detail(arg_employment_detail_object,arg_client_id)
		begin
			ActiveRecord::Base.transaction do
				EmploymentDetailService.trigger_events_for_employment_detail(arg_employment_detail_object, arg_client_id,nil)
				arg_employment_detail_object.save!
				# if arg_employment_detail_object.save!
					# employment = Employment.find(arg_employment_detail_object.employment_id)
					# unless Income.income_information_created_for_this_position_type(arg_client_id, arg_employment_detail_object.position_type, employment.employer_id)
						# income = nil
						# if arg_income_id.present?
						# 	income = Income.find(arg_income_id)
						# end
						# create income
						# if arg_menu == "CLIENT"
						# 	income = Client.find(arg_client_id).incomes.new
						# 	income.incometype = 2811 # "Salary/Wages"
						# 	income.source = Employer.find(employment.employer_id).employer_name
						# 	income.frequency = arg_employment_detail_object.salary_pay_frequency
						# 	income.effective_beg_date = employment.effective_begin_date
						# 	income.recal_ind = 'Y'
						# 	income.employment_id = employment.id
						# 	income.employer_id = employment.employer_id
						# 	# income.position_type = arg_employment_detail_object.position_type
						# 	income.save!
						# 	client_income_object = ClientIncome.new
      #   					client_income_object.client_id = arg_client_id
      #   					client_income_object.income_id = income.id
      #   					client_income_object.save!
						# end
						# # create income_detail
						# income_detail = income.income_details.new
						# income_detail.date_received = arg_employment_detail_object.effective_begin_date
						# income_detail.check_type = 4385 # "Representative"
						# income_detail.gross_amt = arg_employment_detail_object.salary_pay_amt
						# income_detail.cnt_for_convert_ind = 'Y'
						# income_detail.save!
					# end
				# end
			end
			msg = "SUCCESS"
		end
	rescue => err
		error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetail-Service","save_employment_detail",err,AuditModule.get_current_user.uid)
		msg = "Failed to create employment detail - for more details refer to error ID: #{error_object.id}."
		return msg
	end

	def self.update_employment_detail(arg_employment_detail_object,arg_client_id)
		begin
			ActiveRecord::Base.transaction do
				EmploymentDetailService.trigger_events_for_employment_detail(arg_employment_detail_object, arg_client_id,nil)
			end
			msg = "SUCCESS"
		end
		rescue => err
	          	error_object = CommonUtil.write_to_attop_error_log_table("EmploymentDetail-Model","update_employment_detail",err,AuditModule.get_current_user.uid)
	          	msg = "Failed to update employment detail - for more details refer to error ID: #{error_object.id}."
	          	return msg
	end

	def self.trigger_events_for_employment_detail(arg_employment_detail_object, arg_client_id,arg_event_id)
        if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
        	common_action_argument_object = CommonEventManagementArgumentsStruct.new
        	common_action_argument_object.client_id = arg_client_id
        	common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
        	common_action_argument_object.run_month = arg_employment_detail_object.effective_begin_date
        	if arg_event_id.present?
            	common_action_argument_object.event_id = arg_event_id
        	else
	            common_action_argument_object.model_object = arg_employment_detail_object
	            common_action_argument_object.changed_attributes = arg_employment_detail_object.changed_attributes().keys
	            common_action_argument_object.is_a_new_record = arg_employment_detail_object.new_record?
        	end
        	arg_employment_detail_object.save!
        	ls_msg = EventManagementService.process_event(common_action_argument_object)
      	else
      		arg_employment_detail_object.save!
        end
	end

end