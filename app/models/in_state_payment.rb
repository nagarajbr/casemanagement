class InStatePayment < ActiveRecord::Base
has_paper_trail :class_name => 'InstatePaymentVersion',:on => [:update, :destroy]


	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field


	# find existing payments that are not cancelled or returned for a given month
    def self.check_existing_payment_for_month(arg_program_unit_id,arg_payment_month,arg_payment_type)
	    where("program_unit_id = ? and payment_month = ? and payment_type = ? and
	    	 (action_type is null or action_type not in (6054,6055))", arg_program_unit_id,arg_payment_month,arg_payment_type).count > 0
	end

	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end

	def self.check_for_diversion_payments(arg_client_id)
		where("client_id = ? and service_program_id = 3 and (action_type is null or action_type != 6054)", arg_client_id).count > 0
	end

	def self.is_there_a_diversion_payment_with_in_hundred_days(arg_client_id)
		diversion_payments = where("client_id = ? and service_program_id = 3 and (action_type is null or action_type != 6054)", arg_client_id)
		# Rails.logger.debug("diversion_payments = #{diversion_payments.inspect}")
		if diversion_payments.present?
			diversion_payments = diversion_payments.order("issue_date DESC").first
			(Time.now - 100.days..Time.now).cover?(diversion_payments.issue_date)
		else
			return false
		end
	end

	def self.did_the_client_receive_atleast_three_tea_payments(arg_client_id)
		where("client_id = ? and (action_type is null or action_type != 6054) and service_program_id = 1 and payment_type not in (5762, 5763)", arg_client_id).count > 2
	end

    def self.get_payments_for_the_client(arg_client_id)
		where("client_id = ?", arg_client_id)
	end

	def self.get_payments_program_unit(arg_program_unit_id)
		step1 = where("id in (SELECT max(id) FROM in_state_payments where program_unit_id = ? GROUP BY payment_month,payment_type  )",arg_program_unit_id)
		step2 = step1.select("*")
		if step2.present?
			return step2
		end
	end

	def self.did_client_get_tanf_payment_in_run_month(arg_client_id,arg_run_month,arg_srvc_program_id)
		#  get the group for service program
		srvc_prgm_object = ServiceProgram.find(arg_srvc_program_id)
		# TANF category
		if srvc_prgm_object.svc_pgm_category = 6015

			step1 = where("client_id = ? and payment_month = ? and payment_type in (6053,5936,5933,5761,5760) and (action_type is null or action_type not in (6054,6055))",arg_client_id,arg_run_month)
			if 	step1.present?
				got_paid = true
			else
				got_paid = false
			end
        else

        	got_paid = false
        end

		return got_paid
	end


	# def self.temp_add_payment(arg_program_unit_id,arg_client_id,arg_payment_date)

	# 	payment_month = arg_payment_date.strftime("%m/%Y")
	# 	payment_month = payment_month.to_date
	# 	instate_payment_object = InStatePayment.new
	# 	instate_payment_object.program_unit_id = arg_program_unit_id
	# 	instate_payment_object.client_id = arg_client_id
	# 	instate_payment_object.payment_month = payment_month
	# 	instate_payment_object.issue_date = payment_month
	# 	instate_payment_object.dollar_amount = 100.00
	# 	instate_payment_object.action_date = payment_month
	# 	instate_payment_object.payment_type = 5760
	# 	instate_payment_object.action_type = 6019
	# 	instate_payment_object.service_program_id = 1
	# 	if instate_payment_object.save
	# 		time_limits_collection = TimeLimit.where("client_id = ?",arg_client_id)
	# 		if time_limits_collection.present?
	# 			time_limits_object = time_limits_collection.first
	# 		else
	# 			time_limits_object = TimeLimit.new
	# 		end


	# 		time_limits_object.client_id = arg_client_id
	# 		if time_limits_object.federal_count.present?
	# 			time_limits_object.federal_count = time_limits_object.federal_count + 1
	# 		else
	# 			time_limits_object.federal_count = 1
	# 		end

	# 		if time_limits_object.tea_state_count.present?
	# 			time_limits_object.tea_state_count = time_limits_object.tea_state_count + 1
	# 		else
	# 			time_limits_object.tea_state_count = 1
	# 		end
	# 		time_limits_object.save



	# 	else
	# 		logger.debug("test = instate_payment_object - FAILED = #{instate_payment_object.errors_full_messages.last}")
	# 	end
	# end

	def self.get_in_state_payments_without_sanction(arg_program_unit_id)
		where("program_unit_id = ? and sanction is null and (action_type is null or action_type not in (6054, 6055))", arg_program_unit_id)
	end

	def self.get_payment_from_program_unit_id_and_payment_month(arg_program_unit_id, arg_payment_month)
		where("program_unit_id = ? and payment_month = ?", arg_program_unit_id, arg_payment_month)
	end

	def self.is_payment_reimbursed(arg_program_unit_id, arg_payment_month)
		# 6193 Reimbursed
		# 5760 Payment type regular
		where("program_unit_id = ? and payment_month = ? and (action_type is null or action_type not in (6054, 6055)) and payment_type = 5760", arg_program_unit_id, arg_payment_month).count > 0
	end

	def self.tea_extra_payment_in_last_12_months_found?(arg_program_unit_id,arg_payment_month)
		ldt_check_month = arg_payment_month - 12.month
		step1 = InStatePayment.joins("INNER JOIN program_unit_members ON program_unit_members.program_unit_id = in_state_payments.program_unit_id")
		step2 = step1.where("program_unit_members.program_unit_id = ?
							and  program_unit_members.member_status = 4468
							and in_state_payments.payment_month >= ?
							and in_state_payments.payment_type = 5762",arg_program_unit_id, ldt_check_month)
		Rails.logger.debug("record collection for bonus payment = #{step2.inspect}")
		if step2.present?
			return true
		else
			return false
		end
	end


	def self.save_in_state_payment(arg_in_state_payment_object,arg_params_values)
		msg = "SUCCESS"
		previous_value = arg_in_state_payment_object.work_participation_status
		current_value = arg_params_values[:work_participation_status].to_i
		arg_in_state_payment_object.work_participation_status =  arg_params_values[:work_participation_status]
		begin
			ActiveRecord::Base.transaction do
				arg_in_state_payment_object.save!
				if previous_value.present? and current_value.present?
					time_limit = TimeLimit.get_details_by_client_id(arg_in_state_payment_object.client_id)
					if time_limit.present?
						time_limit = time_limit.first
					    if previous_value == 5667 and previous_value != current_value
							if time_limit.tea_state_count.present?
								time_limit.tea_state_count = time_limit.tea_state_count - 1
							end
						elsif current_value == 5667 and previous_value != current_value
							if time_limit.tea_state_count.present?
								time_limit.tea_state_count = time_limit.tea_state_count + 1
							end
						end
						time_limit.save!

				    end
				end

   			end
   			rescue => err
				error_object = CommonUtil.write_to_attop_error_log_table("InStatePayment","save_in_state_payment",err,AuditModule.get_current_user.uid)
				msg = "Error ID: #{error_object.id} - Error when updating in state payment details."
		end
		return msg

	end

end
