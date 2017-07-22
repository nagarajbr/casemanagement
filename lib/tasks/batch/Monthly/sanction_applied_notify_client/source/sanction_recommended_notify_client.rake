# ------------------------------------Batch--------------------------------------------------------

# /****                  PROGRAM DESCRIPTION                                  *
#                           Possible sanctions for client                     *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 12-07-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:          Possible sanctions should create a santion record, *
# *                         ,generate a notice , write to sanction Queue      *
#                             .and a alert to case manager
#
# *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *                                                                                                                                                                                                                                                                                                            *
# *  ERROR FILES,LOG FILES         sanction_work_hours, log_sanction_work_hours          *
# *                                                                           *
# *  RECOVERY  INSTRUCTIONS        Re run the program                                                                         *
# *                                                                           *
# *****************************************************************************
# Batch should run on 20th of every month
task :sanction_applied_notify_client => :environment do
    batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)

    filename = "batch_results/monthly/sanction_applied_notify_client/results/sanction_recommended"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    error_filename = "batch_results/monthly/sanction_applied_notify_client/results/log_sanction_recommended"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    path = File.join(Rails.root, filename )
    error_path = File.join(Rails.root, error_filename )

    # # Create new file called 'filename.txt' at a specified path.
    file = File.new(path,"w+")
    error_file = File.new(error_path,"w+")

    total_activity_hours_count = 0
    activity_hours_not_met_count = 0
    total_alert_created_count = 0
    already_alert_exist = 0
    total_fail_in_alert_creation_count = 0
    notice_generation = 0
    already_notice_generation_present = 0
    notice_generation_failed = 0
    prior_month = Date.today - 1.month
    prior_month_start_date = DateService.get_start_date_of_reporting_month(prior_month)
    prior_month_end_date = DateService.get_end_date_of_reporting_month(prior_month)
    file.write("Begin sanction recommendation process 1 on : " + Date.today.to_s + "\n")
    file.write("Begin date : " + prior_month_start_date.to_s + "\n")
    file.write("End date : " + prior_month_end_date.to_s + "\n")

    work_characteristic = Client.get_work_characteristic_mandatory_for_program_unit # get list of client in a program unit with work characteristics mandatory
    if work_characteristic.present?
        work_characteristic.each do |each_work_characteristic|
            work_hours_not_met = false
            activity_hours = ActivityHour.get_client_activities_for_reporting_month(prior_month_start_date,prior_month_end_date,each_work_characteristic.client_id)
            if activity_hours.present?
                total_activity_hours_count = total_activity_hours_count + 1
            end
            #total_activity_hours_count = activity_hours.length
            absent_hours = ActivityHour.get_client_activities_for_last_12_reporting_months(each_work_characteristic.client_id)
            if absent_hours.sum(:assigned_hours) - absent_hours.sum(:completed_hours) > 80 #If for last 12 reporting months absence hours( excluding holidays) exceed 80
                work_hours_not_met = true
                activity_hours_not_met_count = activity_hours_not_met_count + 1
            elsif activity_hours.sum(:assigned_hours) <= activity_hours.sum(:completed_hours)
                # client completed his assigned hours for reporting month
                work_hours_not_met = false
            elsif activity_hours.sum(:assigned_hours) <= activity_hours.sum(:completed_hours) + 18
                work_hours_not_met = false
            else
                hours = 0
                activity_hours.each do |each_activity|
                    if each_activity.absent_reason == 6295
                        hours = hours + each_activity.absent_hours
                    end
                end
                assigned_hours = activity_hours.sum(:assigned_hours) - hours
                if assigned_hours > activity_hours.sum(:completed_hours) + 18
                    work_hours_not_met = true
                    activity_hours_not_met_count = activity_hours_not_met_count + 1
                end
            end

            if work_hours_not_met == true
                ls_client_name = Client.get_client_full_name_from_client_id(each_work_characteristic.client_id)
                arg_alert_text = " Sanction added (not applied) for :#{ls_client_name}"
                puts (" Sanction added (not applied) for :#{ls_client_name}")
                if each_work_characteristic.case_manager_id.present?
                    assigned_to = each_work_characteristic.case_manager_id
                elsif each_work_characteristic.eligibility_worker_id.present?
                    assigned_to = each_work_characteristic.eligibility_worker_id
                end

                # create a new sanction record
                new_sanction_record  = Sanction.new
                new_sanction_record.client_id = each_work_characteristic.client_id
                new_sanction_record.service_program_id = each_work_characteristic.service_program_id
                new_sanction_record.sanction_type = 3064
                new_sanction_record.infraction_begin_date = Date.today

                begin
                    ActiveRecord::Base.transaction do
                        SanctionService.create_client_sanction_and_notes(new_sanction_record,each_work_characteristic.client_id,'')

                        notice_generation_obj = NoticeGeneration.new
                        notice_generation_obj.notice_generated_date = Date.today
                        notice_generation_obj.action_type = 6719 # "other"
                        notice_generation_obj.action_reason = 6720 #"Sanction Recommended"
                        notice_generation_obj.date_to_print = Date.today
                        notice_generation_obj.notice_status = 6614 # "Pending"
                        notice_generation_obj.processing_location = each_work_characteristic.processing_location
                        notice_generation_obj.service_program_id = each_work_characteristic.service_program_id
                        notice_generation_obj.case_manager_id = assigned_to
                        notice_generation_obj.reference_type = 6345 #program unit
                        notice_generation_obj.reference_id = each_work_characteristic.id
                        notice_present = NoticeGeneration.is_notice_record_required(notice_generation_obj.notice_generated_date,
                                                                      notice_generation_obj.action_type,
                                                                      notice_generation_obj.action_reason,
                                                                      notice_generation_obj.reference_id,
                                                                      notice_generation_obj.reference_type)
                        #Rails.logger.debug("notice_present = #{notice_present.inspect}")
                        if notice_present == false
                            if notice_generation_obj.save!
                                notice_generation = notice_generation + 1
                                name = " Record inserted into notice generation -  #{ls_client_name} client_id = #{each_work_characteristic.client_id}, program_unit_id - #{each_work_characteristic.id}"
                                file.write(name + "\n")
                            else
                                #failed to save
                                notice_generation_failed = notice_generation_failed + 1
                                name = " client failed to insert record into notice generation table-  #{ls_client_name} client_id = #{each_work_characteristic.client_id}, program_unit_id - #{each_work_characteristic.id}"
                                error_file.write(name + "\n")
                            end
                        else
                            # already notice present
                            already_notice_generation_present = already_notice_generation_present + 1
                            name = " Already record present in notice generation table -  #{ls_client_name} client_id = #{each_work_characteristic.client_id}, program_unit_id - #{each_work_characteristic.id}"
                            file.write(name + "\n")
                        end

                        # create an alert
                        alert_for_case_manager = Alert.create_information_only_work_alerts(arg_alert_text,
                                                                                           6348,#arg_alert_category- Business Alert,
                                                                                            6716,#arg_alert_type ,
                                                                                            6367,#arg_alert_for_type -,
                                                                                            each_work_characteristic.client_id,#arg_alert_for_id,
                                                                                            assigned_to,#arg_alert_assigned_to_user_id,
                                                                                            6339,#arg_status,
                                                                                            'Y'#arg_information_only
                                                                                           )

                        #Rails.logger.debug("alert_for_case_manager = #{alert_for_case_manager.inspect}")

                        if alert_for_case_manager == "NEWRECORD"
                            total_alert_created_count = total_alert_created_count + 1
                            name = " client name -  #{ls_client_name} client_id = #{each_work_characteristic.client_id}, program_unit_id - #{each_work_characteristic.id}"
                            file.write(name + "\n")
                        elsif  alert_for_case_manager == "SUCCESS"
                            already_alert_exist = already_alert_exist + 1
                            name = " client name1 -  #{ls_client_name} client_id = #{each_work_characteristic.client_id}, program_unit_id - #{each_work_characteristic.id}"
                            file.write(name + "\n")
                        # pending work task already exists - no need to create one more
                        else
                            total_fail_in_alert_creation_count = total_fail_in_alert_creation_count + 1
                            error = "unable to create alert to case manager to manage for program unit :#{each_work_characteristic.id} for Client:#{ls_client_name}, program_unit_id - #{each_work_characteristic.id} "
                            error_file.write(error + "\n")
                        end #alert_for_case_manager == "NEWRECORD"

                    end# ActiveRecord::Base.transaction do
                end#begin

            end#if work_hours_not_met == true
        end #work_characteristic.each do |each_work_characteristic|
    end #work_characteristic.present?

    file.write("Total clients activity assigned = " + total_activity_hours_count.to_s + "\n")
    file.write("Total clients who failed to meet their work participation hours = " + activity_hours_not_met_count.to_s + "\n")
    file.write("Total alerts created   = " + total_alert_created_count.to_s + "\n")
    file.write("Total alert already exists = " + already_alert_exist.to_s + "\n")
    error_file.write("Total failed to create alert = " + total_fail_in_alert_creation_count.to_s + "\n")
    file.write("Total created notice  = " + notice_generation.to_s + "\n")
    file.write("Total notice already exists = " + already_notice_generation_present.to_s + "\n")
    error_file.write("Total failed to created notice = " + notice_generation_failed.to_s + "\n")



end  #:sanction_applied_notify_client => :environment do
