
# /****                  PROGRAM DESCRIPTION                                 *
# Check for Work pays program unit to have received a payment for prior month,
# if one doesn't exist, write a payment record to payment_line_item table
# 	for prior month.                                                         *
# * .                                                                         *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 10-08-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:    write a payment record to payment_line_item table        *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *																			  *
# *  ERROR FILES,LOG FILES         task_created, task_creation_error          *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *****************************************************************************

task :work_pays_monthly_payments_from_batch => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	filename = "batch_results/monthly/work_pays_monthly_payments/results/log_"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	error_filename = "batch_results/monthly/work_pays_monthly_payments/results/error_log_"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	path = File.join(Rails.root, filename )
	error_path = File.join(Rails.root, error_filename )
	# # Create new file called 'filename.txt' at a specified path.
		file = File.new(path,"w+")
		error_file = File.new(error_path,"w+")
		total_notices_extracted_count = 0
		total_notices_processed_count = 0
		total_notices_process_fail_count = 0
		step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON( program_unit_members.program_unit_id = program_units.id
                                                         AND program_unit_members.MEMBER_STATUS = 4468
                                                         AND program_unit_members.primary_beneficiary = 'Y'
                                                         And program_units.service_program_id = 4
                                                       )

                     INNER JOIN PROGRAM_WIZARDS ON (PROGRAM_WIZARDS.PROGRAM_UNIT_ID=PROGRAM_UNITS.ID
                                                    AND ( PROGRAM_WIZARDS.RUN_ID = ( SELECT RUN_ID
                                                                                     FROM PROGRAM_WIZARDS A
                                                                                     WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNITS.ID
                                                                                     AND A.SUBMIT_DATE IS NOT NULL and A.run_month <= date(date_trunc('month', current_date)-interval '1month')
                                                                                     order by SUBMIT_DATE desc limit 1
                                                                                    )
                                                        )
                                                    )
                    INNER JOIN (select program_unit_id
                                                     from program_unit_participations a
                                                     where a.participation_status = 6043 and
                                                     id = ( select max(id)
                                                           from program_unit_participations
                                                           where program_unit_id = a.program_unit_id
                                                           )
                                                  union
                                                     select program_unit_id
                                                     from program_unit_participations a
                                                     where a.participation_status = 6044 and
                                                     (Extract(month from action_date) >= Extract(month from (current_date  - INTERVAL '1 months'))
                                                     and  Extract(year from action_date) >=  Extract(year from (current_date - INTERVAL '1 months')))
                                                     and  id = ( select max(id) from program_unit_participations
                                                            where program_unit_id = a.program_unit_id)
                                                     )  c
                                        on program_wizards.program_unit_id = c.program_unit_id

                    ")

      step2 = step1.select("program_unit_members.client_id,program_units.id,PROGRAM_WIZARDS.run_id,PROGRAM_WIZARDS.month_sequence")

		program_unit_collection = step2
		if program_unit_collection.present?
			program_unit_collection.each do |each_program_unit|
				ls_client_id = each_program_unit.client_id
				ls_client_name = Client.get_client_full_name_from_client_id(ls_client_id)
				ls_program_unit_id = each_program_unit.id
				ls_run_id = each_program_unit.run_id
				last_month = Date.today - 1.month
				first_of_last_month = last_month.beginning_of_month
				program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(ls_run_id,each_program_unit.month_sequence)
				ld_program_benefit_amount = program_benefit_detail_collection.first.program_benefit_amount
				in_state_payments = InStatePayment.get_payment_from_program_unit_id_and_payment_month(each_program_unit.id,first_of_last_month)
				if in_state_payments.present?
				# already payment is done for previous month
				elsif ls_client_id.present? and ls_program_unit_id.present? and ls_run_id.present?
					total_notices_extracted_count = program_unit_collection.length
					#insert payment record in payment line items
                    #6176- "Work pays",5760-"Regular",6172- "Participant",6191 - "Submitted",6201- "Authorized"
					payment_line_item_object = PaymentLineItem.set_payment_line_item_object(ls_program_unit_id,first_of_last_month,6176,5760,ls_client_id,6172,ld_program_benefit_amount,6191,ls_run_id,6201)
						if payment_line_item_object.save
							if payment_line_item_object.save== true
								#record saved in payment line items
								total_notices_processed_count = total_notices_processed_count + 1
								name = " client name -  #{ls_client_name}"
								file.write(name + "\n")
						    end
						else
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "unable to save record in payment line item :#{ls_client_id} for Client:#{ls_client_name}, program_unit :#{ls_program_unit_id}"
							error_file.write(error + "\n")
						end
				else
						unless ls_client_id.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "unable to get client_id - #{ls_program_unit_id}"
							error_file.write(error + "\n")
						end#assigned_to.present?
						unless ls_program_unit_id.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "unable to get program unit for client- #{ls_client_name}"
							error_file.write(error + "\n")
						end#each_client.id.present?
						unless ls_run_id.present?
							total_notices_process_fail_count = total_notices_process_fail_count + 1
							error = "unable to program wizard run if for - #{ls_program_unit_id}"
							error_file.write(error + "\n")
						end#each_client.client_id.present?
				end

			end
	    end

		file.write("Total extracted = " + total_notices_extracted_count.to_s + "\n")
		file.write("Total processed = " + total_notices_processed_count.to_s + "\n")
		file.write("Total failed to process = " + total_notices_process_fail_count.to_s + "\n")

end  #:work_pays_monthly_payments_from_batch => :environment do

