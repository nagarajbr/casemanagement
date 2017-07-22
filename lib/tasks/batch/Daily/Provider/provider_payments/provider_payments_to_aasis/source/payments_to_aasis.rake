
task :generate_payment_file_to_aasis_for_payment => :environment do

ls_file_date = Date.today.strftime("%m%d%Y")+ Time.now.strftime("%H%M%S")
batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)

filename = "batch_results/daily/Provider/provider_payments/provider_payments_to_aasis/outbound/wisepay0710_" + ls_file_date.to_s + ".txt"
log_filename = "batch_results/daily/Provider/provider_payments/provider_payments_to_aasis/results/wisepay0710_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
zipfile_name = "batch_results/daily/Provider/provider_payments/provider_payments_to_aasis/results/wisepay0710_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".zip"

path = File.join(Rails.root, filename )
log_path = File.join(Rails.root, log_filename )

# Create new file at a specified path.
file = File.new(path,"w+")
log_file = File.new(log_path,"w+")
log_file.puts("Begin payment extract to AASIS")
ls_extract_date = Date.today.strftime("%Y/%m/%d")
ls_extract_time = Time.now.strftime("%H:%M:%S")
log_file.puts("Extract date: " + ls_extract_date.to_s)
log_file.puts("Extract time: " + ls_extract_time.to_s)
ls_write = 0
ls_final_amt = 0
ls_error_cnt = 0
# payment status authorized and payment to providers
arg_payment_status = 6191 #ready for payment
arg_auth_status = 6201 #authorized
arg_new_status = 6192 #sent to vendor
arg_line_item_type_prov = 6178 # payment to provider for supportive services
arg_line_item_type_tea_div = 6177 # 6177 payment to individual for TEA Diversion
payments = PaymentLineItem.get_provider_payments(arg_payment_status,arg_auth_status,arg_line_item_type_prov, arg_line_item_type_tea_div)
if payments.present?
	ls_count = payments.size
	provider_payment_record = 'Header'.ljust(350,' ')
	file.puts(provider_payment_record)
	payments.each do |payment_line_item|
		ls_error = 'N'
		if payment_line_item.line_item_type == arg_line_item_type_prov
			provider_method = Provider.get_provider_information_from_id(payment_line_item.reference_id)
			if provider_method.present?
				provider_object = provider_method.first
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No provider found for payment id : " + payment_line_item.id.to_s)
				next
			end
			# get provider submitted invoice information
			provider_submitted_invoice = PaymentLineItem.get_provider_submitted_invoices_for_payment(payment_line_item.determination_id)
			ls_invoices = ""
			li_counter = 0
			ls_service_auth_id = 0
			if provider_submitted_invoice.present?
				provider_submitted_invoice.each do |arg_submitted_invoice|
					submitted_invoice = arg_submitted_invoice.provider_invoice.to_s
					if submitted_invoice.present?
						if li_counter == 0
							ls_invoices = ls_invoices + submitted_invoice
						else
							ls_invoices = ls_invoices + ", " + submitted_invoice
						end
					end
					li_counter = li_counter + 1
					ls_service_auth_id = arg_submitted_invoice.service_authorization_id
				end
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No invoice or service authorization found for : " + payment_line_item.determination_id.to_s)
				next
			end
			service_authorization_all = ServiceAuthorization.get_service_program_activity_for_line_items(ls_service_auth_id)
			if service_authorization_all.present?
				service_authorization = service_authorization_all.first
				ls_cc_service_prog = service_authorization.service_program_id
				ls_cc_service_type = service_authorization.service_type
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No service authorization or program unit found for : " + ls_service_auth_id.to_s)
				next
			end
			# WTA-WISE-PAY-REF
			provider_payment_record = 'WISE'
		else
			# get client mailing address
			primary_method = ProgramUnitMember.get_primary_beneficiary(payment_line_item.reference_id)
			if primary_method.present?
			   primary = primary_method.first
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No primary found for program unit: " + payment_line_item.reference_id.to_s)
				next
			end
			name_method = Client.where("id = ? ",primary.client_id)
			if name_method.present?
				name = name_method.first
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No primary name found for client id: " + primary.client_id.to_sm)
				next
			end
			address_method = Address.get_mailing_address(primary.client_id, 6150)
			if address_method.present?
				address = address_method.first
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No mailing address found for client id: " + primary.client_id.to_s)
				next
			end
			arg_month = 1
			program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(payment_line_item.determination_id, arg_month)
			if program_benefit_detail_collection.present?
				program_benefit_detail = program_benefit_detail_collection.first
				ls_one_month_benefit = program_benefit_detail.full_benefit
				ls_two_month_benefit = ls_one_month_benefit * 2
			else
				ls_error = 'Y'
				ls_error_cnt = ls_error_cnt + 1
				log_file.puts("No run id found for payment id: " + payment_line_item.id.to_s)
				next
			end
			# end get client name and address
			ls_cc_service_prog = 3 #TEA Diversion
			ls_cc_service_type = 6053 # Regular TEA DIVERSION payment
			# WTA-WISE-PAY-REF
			provider_payment_record = 'TDIV'
		end

		cost_center_info_all = CostCenter.get_cost_center_info(ls_cc_service_prog,ls_cc_service_type)
		if cost_center_info_all.present?
			cost_center_info = cost_center_info_all.first
			ls_cost_center = cost_center_info.cost_center.to_s
			ls_internal_order = cost_center_info.internal_order.to_s
			ls_gl_acct = cost_center_info.gl_account.to_s
		else
			ls_error = 'Y'
			ls_error_cnt = ls_error_cnt + 1
			log_file.puts("Payment Line Item Id: " + payment_line_item.id.to_s)
			log_file.puts("No costs center found for service program: " + ls_cc_service_prog.to_s + ' service type:  ' + ls_cc_service_type.to_s)
			next
		end

		if payment_line_item.line_item_type == arg_line_item_type_prov
			provider_payment_record = provider_payment_record + payment_line_item.determination_id.to_s.rjust(12,'0')
		else
			provider_payment_record = provider_payment_record + payment_line_item.id.to_s.rjust(12,'0')
		end
		# WTA-AMT
		ls_amt = sprintf("%.2f",payment_line_item.payment_amount)
		provider_payment_record = provider_payment_record + ls_amt.to_s.rjust(16,'0')
		# WTA-COST-CENTER
		provider_payment_record = provider_payment_record + ls_cost_center.ljust(10,' ')
		# WTA-INT-ORD
		provider_payment_record = provider_payment_record + ls_internal_order.ljust(12,' ')
		# WTA-GL-ACCT
		provider_payment_record = provider_payment_record + ls_gl_acct.ljust(17,' ')
		# WTA-WBS
		provider_payment_record = provider_payment_record + ' '.ljust(24,' ')

		# WTA-ITEM-TEXT
		# Item text will contain payment line item id, payment type, client id and reference id
		# It will come back from ASSIS is the same format as below and can be used to trace back to creation of payment
		provider_payment_record = provider_payment_record + payment_line_item.id.to_s.ljust(12,' ')
		provider_payment_record = provider_payment_record + payment_line_item.payment_type.to_s.ljust(12,' ')
		provider_payment_record = provider_payment_record + payment_line_item.client_id.to_s.ljust(12,' ')
		provider_payment_record = provider_payment_record + payment_line_item.reference_id.to_s.ljust(12,' ')
		provider_payment_record = provider_payment_record + ' '.ljust(2,' ')
		# WTA-SAP-ID
		if payment_line_item.line_item_type == arg_line_item_type_prov
			provider_payment_record = provider_payment_record + '4'
			provider_payment_record = provider_payment_record + payment_line_item.reference_id.to_s.ljust(9,' ')
		else
			provider_payment_record = provider_payment_record + '9999999999'
		end

		# FILLER
		provider_payment_record = provider_payment_record + ' '.ljust(14,' ')
		# WTA-PAY-METH
		provider_payment_record = provider_payment_record + 'W'
		# WTA-DOC-TXT - confirm the need for this field to be populated
		provider_payment_record = provider_payment_record + ' '.ljust(25,' ')
		# WTA-TAX-CODE

		if payment_line_item.line_item_type == arg_line_item_type_prov
			ls_provider_type = provider_object.classification
			if (ls_provider_type == 6133 || ls_provider_type == 6134 || ls_provider_type == 6137) and
				(ls_cc_service_type == 6208 || ls_cc_service_type == 6210 || ls_cc_service_type == 6211 ||
				ls_cc_service_type == 6215 || ls_cc_service_type == 6217 || ls_cc_service_type == 6219)
		# 	  if reason = 'MS' 'OS' 'RP' 'T2' 'UR' or 'VR' and ls_provider_type(w-9 code) = 'I' 'P' 'O'
				provider_payment_record = provider_payment_record + '07'
		    else
		 		provider_payment_record = provider_payment_record + '00'
			end
			# WTA-ASSIGN-INVOICE-NO
			if ls_invoices.present?
				#log_file.puts(" Id: " + payment_line_item.id.to_s + " invoice number: " + ls_invoices.to_s)
				provider_payment_record = provider_payment_record + ls_invoices.ljust(18,' ')
			else
				provider_payment_record = provider_payment_record + ' '.ljust(18,' ')
			end

		else
			provider_payment_record = provider_payment_record + '00'
			# WTA-ASSIGN-INVOICE-NO
			provider_payment_record = provider_payment_record + 'TEA Diversion'.ljust(18,' ')
		end

		# WTA-AGENCY-HOLD
		provider_payment_record = provider_payment_record + 'Y'
		# WTA-SSN spaces as everybody will be treated as providers
		if payment_line_item.line_item_type == arg_line_item_type_prov
			provider_payment_record = provider_payment_record + ' '.ljust(9,' ')
		else
			provider_payment_record = provider_payment_record + name.ssn.to_s.ljust(9,' ')
		end
		# FILLER
		provider_payment_record = provider_payment_record + ' '.ljust(7,' ')
		# WTA-TAX-ID
		# Get Provider TAX/ id
		if payment_line_item.line_item_type == arg_line_item_type_prov
			ls_tax_ssn_id = provider_object.tax_id_ssn
			provider_payment_record = provider_payment_record + ls_tax_ssn_id.to_s.ljust(9,' ')
		else
			provider_payment_record = provider_payment_record + '0'.ljust(9,'0')
		end

		if payment_line_item.line_item_type == arg_line_item_type_prov
		# FILLER
		# None of the fields below will be required as all service payments will be made to providers
		# individuals will have to be registered as providers and verified by AASIS.
		# WTA-PAYEE-NAME1
		# WTA-PAYEE-NAME2
		# WTA-CITY
		# WTA-STREET1
		# WTA-STATE
		# WTA-ZIP1-5
		# WTA-DASHs
		# WTA-ZIP6-9
		# WTA-ROLL-PYMT
			provider_payment_record = provider_payment_record + ' '.ljust(154,' ')
			provider_payment_record = provider_payment_record + '0'
		else
		# client name and address is required for TEA diversion payments
		# FILLER
			provider_payment_record = provider_payment_record + ' '.ljust(2,' ')
		# WTA-PAYEE-NAME1
			ls_name = name.first_name + name.last_name
			provider_payment_record = provider_payment_record + ls_name.to_s.ljust(35,' ')
			# WTA-PAYEE-NAME2
			if address.address_line2?
				provider_payment_record = provider_payment_record + address.address_line1.to_s.ljust(35,' ')
			else
				provider_payment_record = provider_payment_record + ' '.ljust(35,' ')
			end
			# WTA-CITY
			provider_payment_record = provider_payment_record + address.city.to_s.ljust(35,' ')
			# WTA-STREET1
			if address.address_line2?
				provider_payment_record = provider_payment_record + address.address_line2.to_s.ljust(35,' ')
			else
				provider_payment_record = provider_payment_record + address.address_line1.to_s.ljust(35,' ')
			end
			# WTA-STATE
			ls_state = CodetableItem.find_by("id = ?", address.state)
			provider_payment_record = provider_payment_record + ls_state.short_description.to_s.ljust(2,' ')
			# WTA-ZIP1-5
			provider_payment_record = provider_payment_record + address.zip.to_s.ljust(5,' ')
			# WTA-DASHs
			# WTA-ZIP6-9
			if 	address.zip_suffix?
				provider_payment_record = provider_payment_record + '-'
				provider_payment_record = provider_payment_record + address.zip_suffix.to_s.ljust(4,' ')
			else
				provider_payment_record = provider_payment_record + ' '.ljust(5,' ')
			end
			# WTA-ROLL-PYMT
			provider_payment_record = provider_payment_record + '1'
		end

		# WTA-EOR
		provider_payment_record = provider_payment_record + '.'
		# Write text to the file if no error
		if ls_error == 'N'
			if provider_payment_record.length != 397
				ls_error_cnt = ls_error_cnt + 1
			   	log_file.puts("Incorrect record length: " + provider_payment_record)
			   	log_file.puts("Incorrect record length is : " + provider_payment_record.length.to_s)
			   	#file.puts(provider_payment_record)
			else
		   		ls_payment_line_item_id = payment_line_item.id
		   		if payment_line_item.line_item_type == arg_line_item_type_prov
		   			PaymentLineItem.update_payment_status(ls_payment_line_item_id,arg_new_status)
		   			#add a recored to FMS payment relese queue
		   			common_action_argument_object = CommonEventManagementArgumentsStruct.new

		   			common_action_argument_object.queue_reference_type = 6383 #providerinvoice
		   			common_action_argument_object.queue_reference_id = payment_line_item.determination_id #warrent number
			        arg_event_to_action_mapping_object = EventToActionsMapping.new
			        arg_event_to_action_mapping_object.queue_type = 6653
			        QueueService.create_queue(common_action_argument_object,arg_event_to_action_mapping_object)

		   		else
		   			active_adults_list = ProgramBenefitMember.get_active_adult_client_ids_associated_with_run_id(payment_line_item.determination_id)
		   			if active_adults_list.present?
		   				active_adults_list.each do |active_members|
		   					arg_program_unit_id = payment_line_item.reference_id
				   			arg_client_id = active_members.client_id
				   			arg_payment_date = payment_line_item.payment_date
				   			arg_payment_amt = payment_line_item.payment_amount
				   			arg_payment_type = 5760
				   			arg_service_pgm_id = 3
				   			arg_sanction_type = 0
				   			arg_work_participation_status = 5667
				   			arg_available_date = 0
				   			arg_recoup_amount = 0
				   			if ls_one_month_benefit > payment_line_item.payment_amount
				   				arg_count = 1
				   			else
				   				if ls_two_month_benefit > payment_line_item.payment_amount
				   					arg_count = 2
				   				else
				   					arg_count = 3
				   				end
				   			end
				   			ls_message = PaymentLineItem.update_payment_status_add_instate_payment_update_limit_count(ls_payment_line_item_id,
				   							arg_new_status, arg_program_unit_id, arg_client_id, arg_payment_date, arg_payment_amt,
											arg_payment_type, arg_service_pgm_id, arg_sanction_type, arg_work_participation_status,
											arg_available_date, arg_recoup_amount, arg_count, ls_extract_date,payment_line_item.determination_id)

							if ls_message.present?
			   					if ls_message.to_s == "Good update"
			   					else
			   					#if ls_message.to_s == "Validation failed: Payment month exists"
			   						ls_error = 'Y'
									ls_error_cnt = ls_error_cnt + 1
									log_file.puts(ls_message.to_s + " for Payment Line Item Id" + payment_line_item.id.to_s)
									break
								end
			   				end
				   		end
				   		# if ls_error == 'N'
					   	# 	file.puts(provider_payment_record)
		 		   	# 		ls_final_amt = ls_final_amt + payment_line_item.payment_amount
				   		# 	ls_write = ls_write + 1
				   		# end
			   		else
			   			ls_error = 'Y'
						ls_error_cnt = ls_error_cnt + 1
						log_file.puts("No active adults found for payment line item id: " + payment_line_item.id.to_s)
					end
		   		end
   				if ls_error == 'N'
			   		file.puts(provider_payment_record)
 		   			ls_final_amt = ls_final_amt + payment_line_item.payment_amount
		   			ls_write = ls_write + 1
		   		end
			end
		end
	end
else
# no provider payments found
	log_file.puts("No payments found ")
end
if ls_write != ls_count
	log_file.puts("Records read do not match records written ")
end
log_file.puts("Records read : " + ls_count.to_s)
log_file.puts("Records erred : " + ls_error_cnt.to_s)
log_file.puts("Records written : " + ls_write.to_s)
log_file.puts("Total amount: " + ls_final_amt.to_s)

# Close files.
file.close
file1 = File.open("lib/tasks/batch/Daily/provider/provider_payments/provider_payments_to_aasis/outbound/wisepay0710_" + ls_file_date.to_s + ".txt", 'r+')
#header = file1.read
file1.each do |line|
	line = line.chomp
	ls_write = ls_write + 1
	provider_payment_record = ls_write.to_s.rjust(12,'0')
	ls_total_amt = sprintf("%.2f",ls_final_amt)
	provider_payment_record = provider_payment_record + ls_total_amt.to_s.rjust(17,'0')
	provider_payment_record = provider_payment_record + ls_extract_date.to_s
	provider_payment_record = provider_payment_record + ls_extract_time.to_s
	provider_payment_record = provider_payment_record + ' '.ljust(296,' ')
	file1.rewind
	file1.write(provider_payment_record)
	break
end
log_file.puts("End payment extract to AASIS")
file1.close
log_file.close
# Zip the file and encrypt with the password
require 'archive/zip/codec/null_encryption'
require 'archive/zip/codec/traditional_encryption'
Archive::Zip.archive(
  zipfile_name,
  filename,
  :encryption_codec => lambda do |entry|
    Archive::Zip::Codec::TraditionalEncryption
  end,
  :password => 'arwins20'
)
end
