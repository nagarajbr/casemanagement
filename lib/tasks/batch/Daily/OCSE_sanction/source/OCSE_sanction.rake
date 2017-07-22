# /****                  PROGRAM DESCRIPTION                                  *
# * For all open TANF program units, OCSE sends a sanction on a client add a  *
# * sanction with current service program, sanction type OCSE non-compliance, *
# * infraction begin date as current date a sanction detail for current month *
# * with 25 % implication and release indicator set to 'No' if a regular      *
# * in-state payment does not exist for the client, else the sanction detail  *
# * should be applied for the next month with 25% implication and release     *
# *  indicator set to 'No'                                                    *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *                                                                           *
# *  DATE OF WRITTEN     : 12-30-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                  an alert to the eligibility worker assigned*
# *                                to the program unit on OCSE sanction should*
#                                  be provided and night batch eligibility    *
# *                                record with OCSE sanction as reason        *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *                                                                           *
# *  ERROR FILES,LOG FILES         OCSE_sanction, log_OCSE_sanction           *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *****************************************************************************
task :ocse_sanction => :environment do
  batch_user = User.where("uid = '555'").first
  AuditModule.set_current_user = (batch_user)
  filename = "batch_results/daily/OCSE_sanction/results/OCSE_sanction" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  log_filename = "batch_results/daily/OCSE_sanction/results/log_OCSE_sanction" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  path = File.join(Rails.root, filename)
  log_path = File.join(Rails.root, log_filename)
  # Create new file called 'filename.txt' at a specified path.
  my_file = File.new(path,"w+")
  log_file = File.new(log_path,"w+")
  total_number_of_records = 0

  count_total_sanction_details_record = 0
  count_total_sanction_record = 0
  count_total_failed_sanction_details_record = 0
  count_total_failed_sanction_record = 0
  total_alert_created_count = 0
  already_alert_exist = 0
  total_fail_in_alert_creation_count = 0
  total_night_batch_record_created_count = 0
  already_night_batch_record_exist = 0
  total_fail_to_create_night_batch_record_count = 0
  program_unit_id = ""
  client_id = ""
  first_of_month = ""
  end_of_month = ""
  ocse_file = File.open('lib/tasks/batch/Daily/OCSE_sanction/inbound/OCSE_sanction.txt')
  if ocse_file.present?
      ocse_file.each_line do |line|
        total_number_of_records = total_number_of_records + 1
        program_unit_id = line[0,10]
        program_unit_id = program_unit_id.to_i
        client_id = line[11,10]
        client_id = client_id.to_i
         log_file.puts("")
    my_file.puts("================================================")
    my_file.puts("Started Processing Program Unit: #{program_unit_id}, client id: #{client_id}")
    log_file.puts("================================================")
    log_file.puts("Started Processing Program Unit: #{program_unit_id}, client id: #{client_id}")
    santion_present = false
    sanction_detail_present = false
    alert_for_ed_worker = ""
    create_record = ""

    if  ProgramUnit.get_current_participation_status_value(program_unit_id) != 6044
      progran_unit_object = ProgramUnit.find(program_unit_id)
      regular_payment_present = InStatePayment.is_payment_reimbursed(program_unit_id,Date.today.beginning_of_month)
      if regular_payment_present
        first_of_month = Date.today.beginning_of_month + 1.month
        end_of_month = Date.today.end_of_month + 1.month
      else
        first_of_month = Date.today.beginning_of_month
        end_of_month = Date.today.end_of_month
      end
      #3062 -OCSE Non-Compliance
      ocse_sanction_record = Sanction.where("client_id = ?
                                              and service_program_id = ?
                                              and sanction_type = 3062
                                              and (infraction_end_date is null or infraction_end_date >= ?)",client_id,progran_unit_object.service_program_id,end_of_month)
      if ocse_sanction_record.present?
          ocse_sanction_details = SanctionDetail.where("sanction_id = ?
                                                        and sanction_month = ?",ocse_sanction_record.first.id,first_of_month)
      end
      if regular_payment_present
      # Regular in-state payment exist for the client
          if ocse_sanction_record.present?
            # sanction record with sanction type OCSE Non-Compliance
            santion_present = true
            if ocse_sanction_details.present?
            sanction_detail_present = true
            else
            sanction_detail_present = false
            end
          else
            #create a new sanction record
            santion_present = false
          end

      else
      # Regular in-state payment does not exist for the client
          if ocse_sanction_record.present?
            # sanction record with sanction type OCSE Non-Compliance
            name = "sanction already exits: sanction id - #{ocse_sanction_record.first.id}, program unit id = #{program_unit_id} ,client id - #{client_id}"
            my_file.write(name + "\n")
            santion_present = true
            if ocse_sanction_details.present?
            sanction_detail_present = true
            name = "sanction details already exits: sanction id - #{ocse_sanction_record.first.id},sanction detail id - #{ocse_sanction_details.first.id},program unit id = #{program_unit_id} ,client id - #{client_id}"
            my_file.write(name + "\n")
            else
            sanction_detail_present = false
            end
            #
          else
           #create a new sanction record
           santion_present = false
          end
      end
    else
      #program unit is closed
      count_to_program_unit_closed = count_to_program_unit_closed + 1
    end
     #sanction
      new_sanction_record  = Sanction.new
      new_sanction_record.client_id = client_id
      new_sanction_record.service_program_id = progran_unit_object.service_program_id
      new_sanction_record.sanction_type = 3062
      new_sanction_record.infraction_begin_date = first_of_month

      #sanction details
      new_sanction_detail_object = SanctionDetail.new
      if santion_present == true
        new_sanction_detail_object.sanction_id = ocse_sanction_record.first.id
      end
      new_sanction_detail_object.release_indicatior = "0"
      new_sanction_detail_object.sanction_served = "1"
      new_sanction_detail_object.sanction_indicator = 6111
      new_sanction_detail_object.sanction_month = first_of_month
      ls_client_name = Client.get_client_full_name_from_client_id(client_id)
      arg_alert_text = "#{ls_client_name} in program unit - #{program_unit_id} has sanctioned for Non-Compliance with OCSE "
      Rails.logger.debug("santion_present = #{santion_present.inspect}")
      Rails.logger.debug("sanction_detail_present = #{sanction_detail_present.inspect}")

    if santion_present == true and sanction_detail_present == true
      # both sanction and sanction details present
    elsif santion_present == true and sanction_detail_present == false
      #sanction present and sanction deatils absent
      begin
        ActiveRecord::Base.transaction do
         if new_sanction_detail_object.save!
              count_total_sanction_details_record = count_total_sanction_details_record + 1
              name = "sanction deatils created : sanction id -#{ocse_sanction_record.first.id} ,sanction detail id -#{new_sanction_detail_object.id} ,client id - #{client_id}"
              my_file.write(name + "\n")
            else
              count_total_failed_sanction_details_record = count_total_failed_sanction_details_record + 1
              error = "Failed to create a santion detail record - sanction id - #{ocse_sanction_record.first.id} ,,client id - #{client_id}"
              log_file.write(name + "\n")
            end
          # create_alert = true
          alert_for_ed_worker = Alert.create_information_only_work_alerts(arg_alert_text,#arg_alert_text,
                                                   6348,#arg_alert_category, = Business Alert
                                                   2168, #arg_alert_type, = Sanction
                                                   6367, #arg_alert_for_type, = Sanction
                                                   client_id,#arg_alert_for_id,
                                                   progran_unit_object.eligibility_worker_id, #arg_alert_assigned_to_user_id,
                                                   6339,#arg_status,
                                                   'Y' #arg_information_only
                                                      )

          # create_night_batch_process_record = true
          create_record = CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6599,client_id,Date.today,'Y')
        end
      end
    elsif santion_present == false
      #sanction
        begin
          ActiveRecord::Base.transaction do
            if new_sanction_record.save!
              count_total_sanction_record = count_total_sanction_record + 1
              name = "sanction deatils created - program unit id = #{program_unit_id} ,client id - #{client_id}"
              my_file.write(name + "\n")
            else
              count_total_failed_sanction_record = count_total_failed_sanction_record + 1
              error = "Failed to create a santion record - program unit id = #{program_unit_id} ,client id - #{client_id}"
              log_file.write(name + "\n")
            end
            # Rails.logger.debug("new_sanction_record.id = #{new_sanction_record.id.inspect}")
            new_sanction_detail_object.sanction_id = new_sanction_record.id
            if new_sanction_detail_object.save!
              count_total_sanction_details_record = count_total_sanction_details_record + 1
              name = "sanction deatils created : sanction id -#{new_sanction_record.id} ,sanction detail id -#{new_sanction_detail_object.id} ,client id - #{client_id}"
              my_file.write(name + "\n")
            else
              count_total_failed_sanction_details_record = count_total_failed_sanction_details_record + 1
              error = "Failed to create a santion detail record -sanction id -#{new_sanction_record.id},client id - #{client_id}"
              log_file.write(name + "\n")
            end
            # create_alert = true
            alert_for_ed_worker = Alert.create_information_only_work_alerts(arg_alert_text,#arg_alert_text,
                                                   6348,#arg_alert_category, = Business Alert
                                                   2168, #arg_alert_type, = Sanction
                                                   6367, #arg_alert_for_type, = Sanction
                                                   client_id,#arg_alert_for_id,
                                                   progran_unit_object.eligibility_worker_id, #arg_alert_assigned_to_user_id,
                                                   6339,#arg_status,
                                                   'Y' #arg_information_only
                                                      )
            # create_night_batch_process_record = true
            create_record = CommonEntityService.create_batch_process_entry_if_needed(6524, program_unit_id, 6526,6599,client_id,Date.today,'Y')

            Rails.logger.debug("alert_for_ed_worker = #{alert_for_ed_worker.inspect}")
            Rails.logger.debug("create_record = #{create_record.inspect}")
          end
        end
      end

      if  santion_present == false or sanction_detail_present == false
         if alert_for_ed_worker == "NEWRECORD"
          total_alert_created_count = total_alert_created_count + 1
          name = "Alert created: client name -  #{ls_client_name} client_id = #{client_id}, program_unit_id - #{program_unit_id}"
          my_file.write(name + "\n")
        elsif  alert_for_ed_worker == "SUCCESS"
          already_alert_exist = already_alert_exist + 1
          name = "Alert already exits: client name1 -  #{ls_client_name} client_id = #{client_id}, program_unit_id - #{program_unit_id}"
          my_file.write(name + "\n")
        # pending alert already exists - no need to create one more
        else
          total_fail_in_alert_creation_count = total_fail_in_alert_creation_count + 1
          error = "unable to create alert to eligibility worker to manage for program unit :OCSE Non-Compliance sanction for Client:#{ls_client_name}, program_unit_id - #{program_unit_id} "
          log_file.write(error + "\n")
        end

        if create_record == true
          total_night_batch_record_created_count = total_night_batch_record_created_count + 1
          name = "Night batch record created: client name -#{ls_client_name} client_id = #{client_id}, program_unit_id - #{program_unit_id}"
          my_file.write(name + "\n")
        elsif  create_record == nil
            already_night_batch_record_exist = already_night_batch_record_exist + 1
            name = "Night batch record already exits : client name -#{ls_client_name} client_id = #{client_id}, program_unit_id - #{program_unit_id}"
            my_file.write(name + "\n")
        # pending record already exists - no need to create one more
        else
            total_fail_to_create_night_batch_record_count = total_fail_to_create_night_batch_record_count + 1
            error = "unable to create night batch record for program unit :#{program_unit_id} , client id : #{client_id}"
            log_file.write(error + "\n")
        end
      end
      log_file.puts("================================================")
      log_file.puts("")
      my_file.puts("================================================")
      my_file.puts("")
    end

      my_file.write("total records extracted = " + total_number_of_records.to_s + "\n")
      my_file.write("Total sanction created  =" + count_total_sanction_record.to_s + "\n")
      my_file.write("Total sanction details created  = " + count_total_sanction_details_record.to_s + "\n")
      log_file.write("Total failed to create sanction   =" + count_total_failed_sanction_record.to_s + "\n")
      log_file.write("Total failed to create sanction details = " + count_total_failed_sanction_details_record.to_s + "\n")
      my_file.write("Total alerts created   = " + total_alert_created_count.to_s + "\n")
      my_file.write("Total alert already exists = " + already_alert_exist.to_s + "\n")
      log_file.write("Total failed to create alert = " + total_fail_in_alert_creation_count.to_s + "\n")
      my_file.write("Total night batch record created = " + total_night_batch_record_created_count.to_s + "\n")
      my_file.write("Total night batch record already exists = " + already_night_batch_record_exist.to_s + "\n")
      log_file.write("Total failed to create night batch record = " + total_fail_to_create_night_batch_record_count.to_s + "\n")
  else
    no_sanction_records_found = 'No records found in the file'
    log_file.puts(no_sanction_records_found)
  end
  # # Close the file.
  my_file.close

end