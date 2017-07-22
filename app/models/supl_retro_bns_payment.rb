class SuplRetroBnsPayment < ActiveRecord::Base
has_paper_trail :class_name => 'SuplRetroPaymentVersion',:on => [:update, :destroy]


	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field

    def set_create_user_fields
      	user_id = AuditModule.get_current_user.uid
      	self.created_by = user_id
      	self.updated_by = user_id
    end

    def set_update_user_field
      	user_id = AuditModule.get_current_user.uid
      	self.updated_by = user_id
    end

    validates_presence_of :payment_type, :payment_month, :payment_amount, message: "is required."
    validate :validate_supplement_payment
    # validate :payment_month_uniqueness
    # validate :validate_work_pays_bonus, :on => :create
    # validate :validate_payment_date
    # validate :avoid_retro_payment_if_reimbursed

	def self.get_payments_details_from_program_unit_id(arg_program_unit_id)
		where("program_unit_id = ?",arg_program_unit_id)
	end

	# def self.get_program_types
	# 	CodetableItem.where("id in (6175,6176)")
	# end

	# def self.get_payment_types_for_tea_service_program
	# 	CodetableItem.where("id in (6228,6229)")
	# end

	def self.get_payment_types_for_tea_or_work_pays_service_program
		CodetableItem.where("id in (6228)")
	end

	# def self.get_payment_types_for_work_pays_service_program(arg_program_unit_id)
	# 	ids = CodetableItem.where("id in (6228,6230,6231,6232,6229)").limit(3).select("codetable_items.id")
	# 	ids_of_first_second_or_third_payments = where("program_unit_id = ? and payment_type in (6230, 6231, 6232) and payment_status != 6196",arg_program_unit_id).select("payment_type")
	# 	ids = ids.where("id not in(?)",ids_of_first_second_or_third_payments)
	# 	CodetableItem.where("id in (?) or id = 6233",ids) # 6233 Exit Status
	# end

	def self.save_sup_bonus_retro_record(arg_program_unit_id,
		                            arg_payment_type,
		                            arg_payment_month,
		                            arg_payment_amount,
		                            arg_payment_status
		                            )
	    payment_collection = SuplRetroBnsPayment.where("program_unit_id = ? and payment_month = ? and payment_type = ? and payment_status = ? and payment_amount = ? ",arg_program_unit_id,arg_payment_month,arg_payment_type,arg_payment_status,arg_payment_amount)
          result = nil
            if payment_collection.present?
            	supl_retro_object = payment_collection.first
            	result = 'record_present'
            else
            	supl_retro_object = SuplRetroBnsPayment.new
            	supl_retro_object.program_unit_id = arg_program_unit_id
				supl_retro_object.payment_type  = arg_payment_type
				supl_retro_object.payment_month = arg_payment_month
				supl_retro_object.payment_status  = arg_payment_status
				supl_retro_object.payment_amount = arg_payment_amount
				result = supl_retro_object

            end



	    return result
	end

	def self.create_or_update_supplement_payment(arg_supplement_payment_obj)
		service_program_id = ProgramUnit.get_service_program_id(arg_supplement_payment_obj.program_unit_id)
		primary_contact = PrimaryContact.get_primary_contact(arg_supplement_payment_obj.program_unit_id, 6345)
		# client_id = ProgramUnitMember.get_primary_beneficiary(arg_supplement_payment_obj.program_unit_id).first.client_id
		client_id = primary_contact.client_id if primary_contact.present?
		payment_return_object = PaymentLineItem.save_sup_bonus_retro_payment_line_item(service_program_id,
																		arg_supplement_payment_obj.payment_type,
																		client_id,
																		arg_supplement_payment_obj.program_unit_id,
																		arg_supplement_payment_obj.payment_amount,
																		arg_supplement_payment_obj.payment_month,
																		arg_supplement_payment_obj.id,
																		arg_supplement_payment_obj.payment_status
																		)
		if payment_return_object.class.name == "String"
        	msg = payment_return_object
        else
            begin
	            ActiveRecord::Base.transaction do
	                arg_supplement_payment_obj.save!
	                payment_return_object.determination_id = arg_supplement_payment_obj.id
	                payment_return_object.save!
	            end
            	msg = "SUCCESS"
            rescue => err
                 # logger.debug("in exception  - #{err.inspect}")
                 msg = err.message
            end
        end
        return msg
	end

	def validate_supplement_payment
		program_unit_object = ProgramUnit.find(self.program_unit_id)
         application_date = ClientApplication.get_application_date(program_unit_object.client_application_id)
         if self.payment_month > application_date
         	start_date = Date.today.beginning_of_month
         	end_date = Date.today.end_of_month
	         	if (start_date..end_date).cover?(self.payment_month)
	         		#save the record
	         		return true
	         	elsif end_date < self.payment_month
	         		errors[:base] << "Supplement payment cannot be for future month. "
                    return false
                elsif start_date > self.payment_month
                	payment_month = self.payment_month.strftime("01/%m/%Y").to_date
                	#supplement payment is for previous month
                	if InStatePayment.check_existing_payment_for_month(self.program_unit_id,payment_month,5760)
                		errors[:base] << "Regular instate payment exists for the month and cannot add supplement payment"
                        return false
                	else
                		return true
                	end
	         	end
         else
         	errors[:base] << "Payment date should be after application date (#{CommonUtil.format_db_date(application_date)})"
            return false
         end


	end

	# def payment_month_uniqueness
	# 	result = true
	# 	if self.id.present?
	# 		if self.payment_type.present? && self.payment_month.present? && self.payment_amount.present?
	# 			if self.payment_type == 6228 #Supplement payment
	# 				payment_already_made = SuplRetroBnsPayment.where("program_unit_id = ? and payment_type = ? and payment_month = ? and id != ? and payment_status != 6196",self.program_unit_id, self.payment_type, self.payment_month, self.id).count > 0
	# 				if payment_already_made
	# 					errors[:base] << "Supplement payment paid for #{self.payment_month.strftime("%m/%d/%Y")}."
	# 				end
	# 			else
	# 				payment_already_made = SuplRetroBnsPayment.where("EXTRACT(MONTH FROM payment_month) = ? and EXTRACT(YEAR FROM payment_month) = ? and program_unit_id = ? and payment_type = ? and id != ? and payment_status != 6196",
	# 									self.payment_month.month,self.payment_month.year, self.program_unit_id, self.payment_type, self.id).count > 0
	# 				if payment_already_made
	# 					errors[:base] << "#{CodetableItem.get_short_description(self.payment_type)} payment already made" #for #{self.payment_month.strftime("%m/%d/%Y")}"
	# 				end
	# 			end
	# 		end
	# 	else
	# 		if self.payment_type.present? && self.payment_month.present? && self.payment_amount.present?
	# 			if self.payment_type == 6228 #Supplement payment
	# 				payment_already_made = SuplRetroBnsPayment.where("program_unit_id = ? and payment_type = ? and payment_month = ? and payment_status != 6196",self.program_unit_id, self.payment_type, self.payment_month).count > 0
	# 				if payment_already_made
	# 					errors[:base] << "Supplement payment paid for #{self.payment_month.strftime("%m/%d/%Y")}."
	# 				end
	# 			else
	# 				payment_already_made = SuplRetroBnsPayment.where("EXTRACT(MONTH FROM payment_month) = ? and EXTRACT(YEAR FROM payment_month) = ? and program_unit_id = ? and payment_type = ? and payment_status != 6196",
	# 									self.payment_month.month,self.payment_month.year, self.program_unit_id, self.payment_type).count > 0
	# 				if payment_already_made
	# 					errors[:base] << "#{CodetableItem.get_short_description(self.payment_type)} payment already made." #for #{self.payment_month.strftime("%m/%d/%Y")}"
	# 				end
	# 			end
	# 		end
	# 	end
	# end

	# def validate_payment_date
	# 	if self.payment_month.present?
	# 		program_unit_id = ProgramUnit.find(self.program_unit_id)
	# 		service_program_id = program_unit_id.service_program_id
	# 		appliation_date = ClientApplication.get_application_date(program_unit_id.client_application_id)
	# 		today = Date.today
	# 		if self.payment_type == 6229 # retro
	# 			case service_program_id
	# 		       when 1
	# 		    	    month_start_date = appliation_date
	# 				    month_end_date = today.end_of_month
	# 				    	unless  (month_start_date..month_end_date).cover?(self.payment_month)
	# 							errors[:base] << "Retro payment date must be between application date and current month."
	# 						end
	# 		        when 4
	# 				    month_start_date = appliation_date
	# 				    prior_month = today - 1.month
	# 				    month_end_date = prior_month.end_of_month
	# 				        unless  (month_start_date..month_end_date).cover?(self.payment_month)
	# 							errors[:base] << "Retro payment date must be between application date and prior month."
	# 						end
	# 		      end
 #            else #supplment
 #            	month_start_date = today.beginning_of_month
	# 				month_end_date = today.end_of_month
	# 				    unless  (month_start_date..month_end_date).cover?(self.payment_month)
	# 						errors[:base] << "Payment month should be current month."
	# 					end
	# 		end
	# 	end
	# end

	# def validate_work_pays_bonus
	# 	service_program_id = ProgramUnit.get_service_program_id(self.program_unit_id)
	# 	if service_program_id == 4
	# 		result = true
	# 		result_hash = ""
	# 		case self.payment_type
	# 			when 6230
	# 				in_state_pymts = InStatePayment.get_in_state_payments_without_sanction(self.program_unit_id)
	# 				result_hash = check_for_bonus(in_state_pymts, 3)
	# 			when 6231
	# 				in_state_pymts = InStatePayment.get_in_state_payments_without_sanction(self.program_unit_id)
	# 				result_hash = check_for_bonus(in_state_pymts, 3)
	# 				in_state_pymts = in_state_pymts.where("payment_month > ?",result_hash[:payment_month])
	# 				result_hash = check_for_bonus(in_state_pymts, 6)
	# 			when 6232
	# 				in_state_pymts = InStatePayment.get_in_state_payments_without_sanction(self.program_unit_id)
	# 				result_hash = check_for_bonus(in_state_pymts, 21)
	# 		end
	# 		if result_hash.present?
	# 			result = result_hash[:consec_pymts_available]
	# 		end
	# 		unless result
	# 			if self.payment_type == 6230
	# 				errors[:base] << "Client is not eligible for first bonus, there are no 3 consecutive months participation."
	# 			elsif self.payment_type == 6231
	# 				errors[:base] << "Client is not eligible for second bonus, there are no 6 consecutive months participation."
	# 			elsif self.payment_type == 6232
	# 				errors[:base] << "Client is not eligible for third bonus, there are no 21 consecutive months participation."
	# 			end
	# 		end
	# 		return result
	# 	end
	# end

	# def check_for_bonus(in_state_pymts, arg_months)
	# 	result_hash = {}
	# 	in_state_pymts = in_state_pymts.order("payment_month")
	# 	result_hash[:consec_pymts_available] = false
	# 	in_state_pymts.each do |payment|
	# 		pymt_date = payment.payment_month
	# 		count = 1
	# 		for i in 1..arg_months
	# 			result = in_state_pymts.where("payment_month = ?",pymt_date + i.month).count > 0
	# 		    if result
	# 		    	count = count + 1
	# 		    	if count == arg_months
	# 		    		result_hash[:consec_pymts_available] = true
	# 		    		result_hash[:payment_month] = pymt_date + i.month
	# 		    		Rails.logger.debug("***result_hash2 = #{result_hash.inspect}")
	# 		    		break
	# 		    	end
	# 		    else
	# 		    	break
	# 		    end
	# 		end
	# 		if result_hash[:consec_pymts_available]
	# 			break
	# 		end
	# 	end
	# 	return result_hash
	# end

	# def avoid_retro_payment_if_reimbursed
	# 	if self.payment_type == 6229 # Retro
	# 		if InStatePayment.is_payment_reimbursed(self.program_unit_id,
	# 						Date.civil(self.payment_month.year, self.payment_month.month, 1))
	# 			errors[:base] << "Can't make create a retro since a regular payment is already made for
	# 									#{self.payment_month.strftime("%m/%d/%Y")}."
	# 		end
	# 	end
	# end

	# def self.is_previous_month_bonus_reimbursed(arg_program_unit_id, arg_payment_type)
	# 	where("program_unit_id = ? and payment_type = ? and payment_status = 6193",arg_program_unit_id, arg_payment_type).count > 0
	# end

	# def self.exit_bonus_is_issued(arg_program_unit_id)
	# 	result = false
	# 	exit_bonus = where("program_unit_id = ? and payment_status != 6196 and payment_type = 6233 ",arg_program_unit_id).count > 0
	# 	if exit_bonus.present?
	# 		result = true
	# 	else
	# 	    result = false
	# 	end
	# 	return result
	# end

end
