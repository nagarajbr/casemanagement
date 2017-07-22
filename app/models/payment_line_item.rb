class PaymentLineItem < ActiveRecord::Base
has_paper_trail :class_name => 'PaymentLineItemVersion',:on => [:update, :destroy]

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


	def self.get_provider_submitted_invoices_for_payment(arg_determination_id)
		step1 = PaymentLineItem.joins("INNER JOIN provider_invoices ON payment_line_items.determination_id = provider_invoices.id
									   INNER JOIN service_authorization_line_items ON service_authorization_line_items.provider_invoice_id = provider_invoices.id
									 ").where("provider_invoices.id = ?",arg_determination_id)
		step2 = step1.select("distinct payment_line_items.id,payment_line_items.determination_id,service_authorization_line_items.provider_invoice,
									 service_authorization_line_items.service_authorization_id")
		provider_submitted_invoice = step2
	end

	def self.update_payment_status(arg_payment_id,arg_payment_status)
		update(arg_payment_id, payment_status: arg_payment_status)
	end

	def self.update_return_payment(arg_payment_id,arg_warrant_num,arg_pay_date, arg_payment_status)
		update(arg_payment_id, aasis_warrant_number: arg_warrant_num, paid_date: arg_pay_date, payment_status: arg_payment_status)
	end

	def self.get_provider_payments(arg_payment_status,arg_auth_status,arg_line_item_type1,arg_line_item_type2)
		step1 = where("payment_line_items.line_item_type = ? OR payment_line_items.line_item_type = ? ",arg_line_item_type1,arg_line_item_type2)
		payments = step1.where("payment_line_items.payment_status = ? AND payment_line_items.status = ?",arg_payment_status, arg_auth_status)
		return payments
	end

	def self.get_daily_ebt_payments(arg_payment_status,arg_auth_status,arg_line_item_type1,arg_line_item_type2)
		step1 = where("payment_line_items.line_item_type = ? OR payment_line_items.line_item_type = ? ",arg_line_item_type1,arg_line_item_type2)
		step2 = step1.where("payment_line_items.payment_status = ? AND payment_line_items.status = ?",arg_payment_status, arg_auth_status)
		# Regular/Retro/Supplement payments
		step3 = step2.where("payment_line_items.payment_type = 5760 OR payment_line_items.payment_type = 6229 OR
							 payment_line_items.payment_type = 6228")

		# for current or prior payment month
		payments = step3.where("payment_date <= current_date")
  								#and extract(month from payment_date) <= extract(month from current_date)")
		return payments
	end

	def self.get_monthly_ebt_payments(arg_payment_status,arg_auth_status,arg_line_item_type1,arg_line_item_type2)
		step1 = where("payment_line_items.line_item_type = ? OR payment_line_items.line_item_type = ? ",arg_line_item_type1,arg_line_item_type2)
		step2 = step1.where("payment_line_items.payment_status = ? AND payment_line_items.status = ?",arg_payment_status, arg_auth_status)
		# Regular monthly/TEA Bonuses/WP bonuses
		step3 = step2.where("payment_line_items.payment_type = 5760 OR
							 payment_line_items.payment_type = 5762 OR payment_line_items.payment_type = 5763 OR
							 payment_line_items.payment_type = 6230 OR payment_line_items.payment_type = 6231 OR
							 payment_line_items.payment_type = 6232 OR payment_line_items.payment_type = 6233")
		l_next_month = Date.today.at_beginning_of_month.next_month.strftime("%F")
		payments = step3.where("payment_date <= ?",l_next_month)
		return payments
	end
	def self.get_payment_record_for_program_unit_and_run_month(arg_program_unit_id,arg_run_month)
		where("reference_id = ? and payment_date = ?",arg_program_unit_id,arg_run_month)
	end

	def self.get_payment_record_for_provider_invoice(arg_provider_invoice)
		where("determination_id = ?",arg_provider_invoice)
	end

	def self.update_payment_status_add_instate_payment_update_limit_count(arg_payment_id,arg_payment_status,arg_program_unit_id, arg_client_id, arg_payment_date, arg_payment_amt,
									arg_payment_type, arg_service_pgm_id, arg_sanction_type, arg_work_participation_status,
									arg_available_date, arg_recoup_amount, arg_count, arg_extract_date, arg_run_id)
		error_message = "Good update"
		payment_object = PaymentLineItem.find(arg_payment_id)
		payment_object.payment_status = arg_payment_status
		if (arg_payment_type == 6228 || arg_payment_type == 6229 || arg_payment_type == 6230 ||
		    arg_payment_type == 6231 || arg_payment_type == 6232 || arg_payment_type == 6233)
		   issue_object = SuplRetroBnsPayment.find(arg_run_id)
		   #puts ("Supp/retro_id :" + issue_object.id.to_s + "payment_line_items.id : " + payment_object.id.to_s)
		   issue_object.payment_status = arg_payment_status
		end
		instate_payment_object = InStatePayment.new
		instate_payment_object.program_unit_id = arg_program_unit_id
		instate_payment_object.client_id = arg_client_id
		instate_payment_object.payment_month = arg_payment_date
		instate_payment_object.issue_date = arg_extract_date
		if arg_available_date != 0
			instate_payment_object.available_date = arg_available_date
		end
		instate_payment_object.dollar_amount = arg_payment_amt
		if arg_recoup_amount != 0
			instate_payment_object.recoup_amount = arg_recoup_amount
		end
		instate_payment_object.payment_type = arg_payment_type
		instate_payment_object.service_program_id = arg_service_pgm_id
		if arg_sanction_type != 0
			instate_payment_object.sanction = arg_sanction_type
		end
		if arg_work_participation_status != 0
			instate_payment_object.work_participation_status = arg_work_participation_status
		end

		l_tea_state_count = 0
		l_wp_state_count = 0
		l_fed_count = 0
		if arg_client_id.present?
			time_limits_collection = TimeLimit.where("client_id = ?", arg_client_id)
		      if time_limits_collection.present?
		        time_limits_object = time_limits_collection.first
		      else
		        time_limits_object = TimeLimit.new
		        time_limits_object.client_id = arg_client_id
		      end
		      # update federal count
		      if time_limits_object.federal_count.present?
		      	  l_fed_count = time_limits_object.federal_count
		          time_limits_object.federal_count = time_limits_object.federal_count + arg_count
		      else
		          time_limits_object.federal_count = arg_count
		      end
		      # update TEA State count
		      if (arg_service_pgm_id == 3) ||
		         ((arg_service_pgm_id == 1) && (arg_work_participation_status == 5666 ||
		      		arg_work_participation_status == 5667 || arg_work_participation_status == 5700 || arg_work_participation_status == 5691 ||
		      		arg_work_participation_status == 5672 || arg_work_participation_status == 5701 || arg_work_participation_status == 5686 ||
		      		arg_work_participation_status == 5680 || arg_work_participation_status == 5711 || arg_work_participation_status == 5692 ||
		      		arg_work_participation_status == 5669))
		        	if time_limits_object.tea_state_count.present?
		        		l_tea_state_count = time_limits_object.tea_state_count
		            	time_limits_object.tea_state_count = time_limits_object.tea_state_count + arg_count
		        	else
		            	time_limits_object.tea_state_count = arg_count
		        	end
		      else
		        if arg_service_pgm_id == 4
		          if time_limits_object.work_pays_state_count.present?
		          	  l_wp_state_count = time_limits_object.work_pays_state_count
		              time_limits_object.work_pays_state_count = time_limits_object.work_pays_state_count + arg_count
		          else
		              time_limits_object.work_pays_state_count = arg_count
		          end
		      	end
		      end
	    end
	    if (arg_service_pgm_id == 1) && (l_fed_count > 60)
	    	error_message = 'Time limit met'
	    else
	    	if (arg_service_pgm_id == 4) && (l_wp_state_count > 24 || l_fed_count > 60)
	    		error_message = 'Time limit met'
	    	else
	    		begin ActiveRecord::Base.transaction do
					payment_object.save!
					if (arg_payment_type == 6228 || arg_payment_type == 6229 || arg_payment_type == 6230 ||
		   			    arg_payment_type == 6231 || arg_payment_type == 6232 || arg_payment_type == 6233)
		   				issue_object.save!
		   			end
					instate_payment_object.save!
					if arg_client_id.present?
					   time_limits_object.save!
					end
				end
				rescue => err
					error_message = err.message.to_s
				end
			end
		end
		return error_message
	end



	def self.save_sup_bonus_retro_payment_line_item(arg_service_program,
						                            arg_payment_type,
						                            arg_client_id,
						                            arg_program_unit_id,
						                            arg_payment_amount,
						                            arg_run_month,
						                            arg_determination_id,
						                            arg_payment_status
						                            )
		# Rule 1: Only One payment per program unit and payment type per month.
		payment_line_item_collection = PaymentLineItem.where("reference_id = ? and payment_date = ? and payment_type = ? and determination_id = ?",arg_program_unit_id,arg_run_month,arg_payment_type,arg_determination_id)
		if payment_line_item_collection.present?
			payment_line_item_object = payment_line_item_collection.first
			# Rule : If payment status is not generated - that means payment record is sent to AASIS. - No Modification allowed.
			if payment_line_item_object.payment_status == 6191 ||  payment_line_item_object.payment_status == 6196 # 6191 Generated, 6196 Cancelled
				lb_save = true
			else
				lb_save = false
			end
		else
			lb_save = true

			payment_line_item_object = PaymentLineItem.new
		end
		msg = ""
		if lb_save
			if arg_service_program == 1 # TEA
				 payment_line_item_object.line_item_type = 6175 # TEA
			elsif arg_service_program == 4 # WORKPAYS
				 payment_line_item_object.line_item_type = 6176 # WORKPAYS
			end
			payment_line_item_object.payment_type = arg_payment_type
			payment_line_item_object.client_id = arg_client_id
			payment_line_item_object.beneficiary = 6172 # pARTICIPANT
			payment_line_item_object.reference_id = arg_program_unit_id
			payment_line_item_object.payment_amount = arg_payment_amount
			payment_line_item_object.payment_date = arg_run_month
			payment_line_item_object.payment_status = arg_payment_status
			payment_line_item_object.determination_id = arg_determination_id
	        payment_line_item_object.status = 6201 #Authorized.
	        payment_line_item_object.program_unit_id = arg_program_unit_id
	    else
	    	msg = "This Payment type for month: #{arg_run_month} is already processed."
	    end

	    if msg.present?
	    	return msg
	    else
	    	return payment_line_item_object
	    end

	end

	def self.set_payment_line_item_object(arg_program_unit_id,
										 arg_payment_month,
		                                 arg_line_item_type,
		                                 arg_payment_type,
		                                 arg_client_id,
		                                 arg_beneficiary,
		                                 arg_payment_amount,
		                                 arg_payment_status,
		                                 arg_determination_id,
		                                 arg_status)
		payment_collection = PaymentLineItem.where("reference_id = ? and payment_date = ? and payment_type = ?",arg_program_unit_id,arg_payment_month,arg_payment_type)
		if payment_collection.present?
			payment_line_item_object = payment_collection.first
		else
			payment_line_item_object = PaymentLineItem.new
		end
		payment_line_item_object.line_item_type = arg_line_item_type
		payment_line_item_object.payment_type = arg_payment_type
		payment_line_item_object.client_id = arg_client_id
		payment_line_item_object.beneficiary = arg_beneficiary
		payment_line_item_object.reference_id = arg_program_unit_id
		payment_line_item_object.payment_amount = arg_payment_amount
		payment_line_item_object.payment_date = arg_payment_month
		payment_line_item_object.payment_status = arg_payment_status
		payment_line_item_object.determination_id = arg_determination_id
		payment_line_item_object.status = arg_status
		payment_line_item_object.program_unit_id = arg_program_unit_id
		return payment_line_item_object
	end

	def self.service_payments_for_client(arg_client_id)
		 step1 = joins("INNER JOIN providers  f
						on (f.id = payment_line_items.reference_id
						    and payment_line_items.line_item_type = 6178)
				        INNER JOIN program_units c
						ON  c.id =  payment_line_items.program_unit_id
				        INNER JOIN program_unit_participations d
						ON d.program_unit_id = c.id
				        INNER JOIN service_programs e
						on e.id = c.service_program_id
				        Inner JOIN users
						on c.case_manager_id = users.uid")
        step2 = step1.where(" d.id = (select max(z.id)
                                 from program_unit_participations as z
                              where z.program_unit_id = c.id )
                              and payment_line_items.client_id = ?",arg_client_id)
        step3 = step2.select(" payment_line_items.id ,
               				   payment_line_items.client_id as client_id ,
               				   payment_line_items.determination_id as determination_id  ,
                               e.title ,
							   c.id as programunitid,
							   payment_line_items.payment_date as payment_date ,
							   payment_line_items.payment_amount as payment_amount,
							   payment_line_items.payment_status as payment_status,
							   payment_line_items.aasis_warrant_number as aasis_warrant_number ,
							   payment_line_items.paid_date as paid_date,
							   f.provider_name as provider_name,
							   users.name as name")
        step4 = step3.order("payment_date desc")

	end

    def self.service_payments_for_client_and_payment_id(arg_client_id,arg_id)
 step1 = joins("INNER JOIN providers  f
    	 	            on (f.id = payment_line_items.reference_id
    	 	               and payment_line_items.line_item_type = 6178)
				        INNER JOIN program_units c
				        ON  c.id =  payment_line_items.program_unit_id
				        INNER JOIN program_unit_participations d
				        ON d.program_unit_id = c.id
				        INNER JOIN service_programs e
				        on e.id = c.service_program_id
				        Inner JOIN users
				        on c.case_manager_id = users.uid"
				        )
        step2 = step1.where("d.id = (select max(z.id)
              					        from program_unit_participations as z
              				where z.program_unit_id = c.id )
                            and payment_line_items.client_id = ?
                            and payment_line_items.id = ?", arg_client_id,arg_id)
        step3 = step2.select("  payment_line_items.id as id ,
               				   payment_line_items.client_id as client_id ,
               				   payment_line_items.determination_id,
                               e.title  ,
							   c.id as programunitid,
							   payment_line_items.payment_date as payment_date ,
							   payment_line_items.payment_amount as payment_amount,
							   payment_line_items.payment_status as payment_status,
							   payment_line_items.aasis_warrant_number as aasis_warrant_number ,
							   payment_line_items.paid_date as paid_date,
							   f.provider_name as provider_name,
							   users.name as name "
							   )

    end
end
#end
