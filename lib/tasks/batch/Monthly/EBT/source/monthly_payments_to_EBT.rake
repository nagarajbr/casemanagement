# Regular monthly/TEA Bonuses/WP bonuses
task :monthly_payment_file_to_ebt_for_payments => :environment do
  batch_user = User.where("uid = '555'").first
  AuditModule.set_current_user=(batch_user)

  ls_file_date = Date.today.strftime("%m%d%Y")+ Time.now.strftime("%H%M%S")
  ls_tomorrow = Date.tomorrow.strftime("%Y%m%d").to_s
  ls_next_month = Date.today.at_beginning_of_month.next_month.strftime("%Y%m%d")

  filename = "batch_results/monthly/EBT/results/ebt_month_pay_" + ls_file_date.to_s + ".txt"
  log_filename = "batch_results/monthly/EBT/results/ebt_month_pay_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

  path = File.join(Rails.root, filename )
  log_path = File.join(Rails.root, log_filename )

  # Create new file at a specified path.
  file = File.new(path,"w+")
  log_file = File.new(log_path,"w+")

  ls_extract_date = Date.today.strftime("%Y-%m-%d")
  log_file.puts("Begin EBT payment process ")
  log_file.puts("Extract date: " + ls_extract_date.to_s)
  log_file.puts('Available Date: ' + ls_tomorrow)
  ls_write = 0
  ls_add = 0
  ls_cancel = 0
  ls_final_amt = 0
  ls_error_cnt = 0

  # payment status authorized and payment to EBT
  arg_payment_status = 6191 #ready for payment
  arg_auth_status = 6201 #authorized
  arg_new_status = 6193 # payment sent fpr processing to vendor
  arg_line_item_type_workp = 6176 # Work pays
  arg_line_item_type_tea = 6175 # TEA
  payments = PaymentLineItem.get_monthly_ebt_payments(arg_payment_status,arg_auth_status,arg_line_item_type_workp, arg_line_item_type_tea)
  # Rails.logger.debug("payments - #{payments.inspect}")
  ls_count = payments.size
  #Header record start
  ebt_payment_record = 'HB'
  ebt_payment_record = ebt_payment_record + ' '.to_s.rjust(15,' ')
  ebt_payment_record = ebt_payment_record + 'ARDWST '
  ebt_payment_record = ebt_payment_record + 'CASH MONTHLY    '
  ebt_payment_record = ebt_payment_record + "#{Date.today.strftime("%Y%m%d")}"+"#{Time.now.strftime("%H%M")}"
  ebt_payment_record = ebt_payment_record + ' '.to_s.rjust(29,' ')
  file.puts(ebt_payment_record)
  #Header record end

  if payments.present?
    # Rails.logger.debug("payments*** - #{payments.inspect}")
    payments.each do |payment_line_item|
      # Rails.logger.debug("payment_line_item*** - #{payment_line_item.inspect}")
      puts ("id : " + payment_line_item.id.to_s)
      ls_error = 'N'
      #EBT-BN-MD-REFRESH-ACTION                X(01)     Defualt values 'A' for payment add and 'D' for payment cancel'
      ebt_payment_record = 'A'
      #Check if open program unit exists for regular payment
      # work pays can be closed and still get it's last payment, check for rules when inserting to payment line items
      # if payment_line_item.payment_type == 5760
      #             ls_current_participation_status = ProgramUnit.get_current_participation_status(payment_line_item.reference_id)
      #             if ls_current_participation_status != 'Open'
      #                             ls_error = 'Y'
      #                             ls_error_cnt = ls_error_cnt + 1
      #                             log_file.puts("No open program unit found for payment id : " + payment_line_item.id.to_s)
      #                             next
      #             end
      # end

      #EBT-BN-MD-EBT-ACCT-NUM   9(12)      EBT account number as assigned by system
      # Rails.logger.debug("payment_type - #{payment_line_item.payment_type.inspect}")
      if payment_line_item.payment_type == 5760  #regular TEA or Work pays
        # Rails.logger.debug("InStatePayment*** - #{(InStatePayment.check_existing_payment_for_month(payment_line_item.reference_id,payment_line_item.payment_date,payment_line_item.payment_type)).inspect}")
        if InStatePayment.check_existing_payment_for_month(payment_line_item.reference_id,
          payment_line_item.payment_date,payment_line_item.payment_type)
          ls_error = 'Y'
          ls_error_cnt = ls_error_cnt + 1
          log_file.puts("Past payment exists for payment id : " + payment_line_item.id.to_s)
          next
        end
      end
      l_account_number_collection = ProgramUnitRepresentative.get_account_of_primary_of_program_unit(payment_line_item.reference_id)
      # Rails.logger.debug("l_account_number_collection**** - #{l_account_number_collection.inspect}")
      if l_account_number_collection.present?
        l_account_object = l_account_number_collection
        puts (" Account number is: " + l_account_object.first.account_number.to_s + "for Pgm unit : " + payment_line_item.reference_id.to_s)
      else
        ls_error = 'Y'
        ls_error_cnt = ls_error_cnt + 1
        log_file.puts("No account number found for payment id : " + payment_line_item.id.to_s)
        next
      end
      ebt_payment_record = ebt_payment_record + l_account_object.first.account_number.to_s.rjust(12,'0')
      # EBT-BN-MD-CASE-NUM            X(09)     TEA/WORK-PAYS case number
      ebt_payment_record = ebt_payment_record + payment_line_item.reference_id.to_s.rjust(9,'0')
      # EBT-BN-MD-BENEFIT-TYPE       X(06)     Category of benefit
      if payment_line_item.line_item_type == 6175 #TEA
        if (payment_line_item.payment_type == 5760)
          ebt_payment_record = ebt_payment_record + 'TEA'.to_s.ljust(6,' ')
        else
          if payment_line_item.payment_type == 5764
            ebt_payment_record = ebt_payment_record + 'TEA-B'.to_s.ljust(6,' ')
          else
            ebt_payment_record = ebt_payment_record + 'TEA-T'.to_s.ljust(6,' ')
          end
        end
     else
        if payment_line_item.payment_type == 5760
          ebt_payment_record = ebt_payment_record + 'WORK'.to_s.ljust(6,' ')
        else
          ebt_payment_record = ebt_payment_record + 'WP-B'.to_s.ljust(6,' ')
        end
      end

      # EBT-BN-MD-AUTH-NUM          X(10)     System assigned authorization number
      ebt_payment_record = ebt_payment_record + payment_line_item.id.to_s.rjust(10,'0')
      # EBT-BN-MD-AUTH-AMT            9(05)      Authorized benefit amount
      ls_amt = sprintf("%.2f",payment_line_item.payment_amount)
      ebt_payment_record = ebt_payment_record + ls_amt.to_s.rjust(7,'0')
      # EBT-BN-MD-AVAIL-DATE          9(08)      Available date
      ebt_payment_record = ebt_payment_record + ls_tomorrow
      # EBT-BN-MD-AVAIL-TIME          9(04)      Available time defaulted to 0001 (HHMM)
      ebt_payment_record = ebt_payment_record + '1800'
      # EBT-BN-MD-COUNTY X(03)     Service county of case
      ls_program_unit = ProgramUnit.get_completed_program_units(payment_line_item.reference_id)
      if ls_program_unit.present?
        ls_program_unit_first = ls_program_unit.first
      else
        ls_error = 'Y'
        ls_error_cnt = ls_error_cnt + 1
        log_file.puts("No program unit found for payment id : " + payment_line_item.id.to_s)
        next
      end
      ebt_payment_record = ebt_payment_record + ls_program_unit_first.processing_location.to_s.truncate(3).ljust(3,' ')
      # EBT-BN-MD-BENEFIT-STATUS X(01)     Default 'A' for active
      ebt_payment_record = ebt_payment_record + 'A'
      # EBT-BN-MD-HOUSEHOLD-SIZE               9(02)      Household size of case
      ebt_payment_record = ebt_payment_record + ' '.to_s.ljust(2,' ')
      # EBT-BN-MD-RESIDENT-CNTY   9(03)      resident county of case
      ebt_payment_record = ebt_payment_record + ' '.to_s.ljust(3,' ')
      # EBT-BN-MD-DISASTER-ID         X(04)     Disaster id if applicable
      ebt_payment_record = ebt_payment_record + ' '.to_s.ljust(4,' ')
      # EBT-BN-MD-FILLER      X(10)     NA
      ebt_payment_record = ebt_payment_record + ' '.to_s.ljust(10,' ')

      arg_program_unit_id = payment_line_item.reference_id
      arg_client_id = nil
      arg_payment_date = payment_line_item.payment_date
      arg_payment_amt = payment_line_item.payment_amount
      arg_payment_type = payment_line_item.payment_type
      arg_recoup_amount = 0
      arg_work_participation_status = 0
      arg_sanction_type = 0
      # available date is current day plus one
      arg_available_date = Date.tomorrow
      # count is zeros for bonus payments and for child only cases
      arg_count = 0
      if payment_line_item.line_item_type == 6175
        arg_service_pgm_id = 1 # TEA
      elsif payment_line_item.line_item_type == 6176
        arg_service_pgm_id = 4 # Work pays
      elsif payment_line_item.line_item_type == 6177
        arg_service_pgm_id = 3 # TEA Diversion
      end
      ls_payment_line_item_id = payment_line_item.id
      l_determination_id = payment_line_item.determination_id
      ls_update_ind = 'N'

      #get all active adults to write an instate payment record
      active_adults_list = ProgramBenefitMember.get_active_adult_client_ids_associated_with_run_id(payment_line_item.determination_id)
      # Rails.logger.debug("active_adults_list**** - #{active_adults_list.inspect}")
      if active_adults_list.present?
        active_adults_list.each do |active_members|
          arg_client_id = active_members.client_id
          if payment_line_item.payment_type == 5760
            if payment_line_item.line_item_type == 6175
              # get current work participation for TEA program units
              arg_work_participation_status = ClientCharacteristic.get_current_work_characteristics(arg_client_id,payment_line_item.payment_date)
            else
              arg_work_participation_status = 5667 # Mandatory
            end
            # get current sanction
            arg_month = 1
            program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(payment_line_item.determination_id, arg_month)
            # Rails.logger.debug("program_benefit_detail_collection**** - #{program_benefit_detail_collection.inspect}")
            if program_benefit_detail_collection.present?
              program_benefit_detail = program_benefit_detail_collection.first
            else
              ls_error = 'Y'
              ls_error_cnt = ls_error_cnt + 1
              log_file.puts("No program benefit detail found for payment id: " + payment_line_item.id.to_s)
              next
            end
            if program_benefit_detail.sanction_indicator.present?
              if program_benefit_detail.sanction_indicator != 6179 # no sanction
                arg_sanction_type = Sanction.get_current_sanction_type_for_client(arg_service_pgm_id, arg_payment_date, arg_client_id)
                # Rails.logger.debug("arg_sanction_type**** - #{arg_sanction_type.inspect}")
              end
            end
          end
          # use recoup amount if recoupment possible
          arg_recoup_amount = 0
          if payment_line_item.payment_type == 5760
            arg_count = 1
          end
          # Rails.logger.debug("arg_client_id = #{arg_client_id.inspect}")
          ls_message = PaymentLineItem.update_payment_status_add_instate_payment_update_limit_count(ls_payment_line_item_id,
                                                                          arg_new_status, arg_program_unit_id, arg_client_id, arg_payment_date, arg_payment_amt,
                                                                          arg_payment_type, arg_service_pgm_id, arg_sanction_type, arg_work_participation_status,
                                                                          arg_available_date, arg_recoup_amount, arg_count, ls_extract_date, l_determination_id)
          # Rails.logger.debug("ls_message**** - #{ls_message.inspect}")
          if ls_message.present?
            if ls_message.to_s == "Good update"
            else
              #if ls_message.to_s == "Validation failed: Payment month exists"
              ls_error = 'Y'
              ls_error_cnt = ls_error_cnt + 1
              log_file.puts(ls_message.to_s + " for Payment Line Item Id" + payment_line_item.id.to_s)
              break
            end
            if ls_message.to_s == "Time limit met"
              ls_error = 'Y'
              ls_error_cnt = ls_error_cnt + 1
              log_file.puts(ls_message.to_s + " for Payment Line Item Id" + payment_line_item.id.to_s)
              break
            end
          end
        end
      else
        if arg_service_pgm_id == 4 #work pays has to have an active adult
          ls_error = 'Y'
          ls_error_cnt = ls_error_cnt + 1
          log_file.puts(" No active adults for Payment Line Item Id" + payment_line_item.id.to_s)
          break
        else
          ls_update_ind = 'Y'
        end
      end
      if ls_update_ind == 'Y'
        # Rails.logger.debug("arg_client_id123*** = #{arg_client_id.inspect}")
        ls_message = PaymentLineItem.update_payment_status_add_instate_payment_update_limit_count(ls_payment_line_item_id,
                                                                                                        arg_new_status, arg_program_unit_id, arg_client_id, arg_payment_date, arg_payment_amt,
                                                                                                        arg_payment_type, arg_service_pgm_id, arg_sanction_type, arg_work_participation_status,
                                                                                                        arg_available_date, arg_recoup_amount, arg_count, ls_extract_date, l_determination_id)
        # Rails.logger.debug("ls_message123**** - #{ls_message.inspect}")
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
      if ls_error == 'N'
        if ebt_payment_record.length != 80
          ls_error_cnt = ls_error_cnt + 1
          log_file.puts("Incorrect record length: " + ebt_payment_record)
        else
          file.puts(ebt_payment_record)
          ls_final_amt = ls_final_amt + payment_line_item.payment_amount
          ls_write = ls_write + 1
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
  ls_final_amount = sprintf("%.2f",ls_final_amt)
  log_file.puts("Total amount: " + ls_final_amount.to_s)

  ls_add = ls_write
  ls_write = ls_write + 2
  #Trailer record start
  ebt_payment_record = 'TB'
  ebt_payment_record = ebt_payment_record + ls_write.to_s.rjust(9,'0')
  ebt_payment_record = ebt_payment_record + ls_add.to_s.rjust(9,'0')
  ebt_payment_record = ebt_payment_record + '0'.to_s.rjust(9,'0')
  ebt_payment_record = ebt_payment_record + ls_cancel.to_s.rjust(9,'0')
  ebt_payment_record = ebt_payment_record + ls_final_amount.to_s.rjust(12,'0')
  ebt_payment_record = ebt_payment_record + ' '.to_s.rjust(31,'0')
  file.write(ebt_payment_record)
  #Trailer record end
  log_file.puts("End EBT payment process ")
  file.close
  log_file.close
end
