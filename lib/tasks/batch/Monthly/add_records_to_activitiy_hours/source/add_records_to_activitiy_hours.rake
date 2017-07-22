# /****                  PROGRAM DESCRIPTION                                  *
# * add records to activitiy_hours table for all open activities for the given *
# *  reporting month based on begin date, end date, duration and hours per day *
# * .                                                                         *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 11-24-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *                                                                           *
# *  ERROR FILES,LOG FILES         task_created, task_creation_error          *
# *                                                                           *
# *  RECOVERY  INSTRUCTIONS        Re run the program                                                                         *
# *                                                                           *
# *****************************************************************************
task :add_records_to_activitiy_hours => :environment do
batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
filename = "batch_results/monthly/add_records_to_activitiy_hours/results/task_created" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
error_filename = "batch_results/monthly/add_records_to_activitiy_hours/results/task_creation_error" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
path = File.join(Rails.root, filename )
error_path = File.join(Rails.root, error_filename )
# # Create new file called 'filename.txt' at a specified path.
file = File.new(path,"w+")
error_file = File.new(error_path,"w+")
activity_hour_extracted_count = 0
activity_hour_processed_count = 0
activity_hour_process_fail_count = 0
start_day_id = ""
file.puts("Activity hours batch process start")
end_of_the_month = Date.today.end_of_month
# Rails.logger.debug("end_of_the_month = #{end_of_the_month.inspect }")
    step1 = ProgramUnit.joins("inner join action_plans on action_plans.program_unit_id = program_units.id
                               inner join action_plan_details  on action_plan_details.action_plan_id = action_plans.id ")
    step2 = step1.where("action_plan_details.end_date is  null and action_plan_details.start_date <= ?",end_of_the_month)
    step3 = step2.select("action_plan_details.id as action_plan_detail_id , action_plans.client_id, program_units.id as program_unit_id,action_plan_details.start_date as action_plan_detail_start_date")
    action_plan_details_collection = step3
    activity_hour_extracted_count = action_plan_details_collection.length
    action_plan_details_collection.each do |action_plan_detail|
      @action_plan_detail = ActionPlanDetail.find(action_plan_detail.action_plan_detail_id)
      schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
      number_of_weeks_to_be_added = @action_plan_detail.get_duration - ActivityHour.get_number_of_weeks_added(@action_plan_detail.id)
      activity_end_date = DateService.get_end_date_of_reporting_month(Date.today)
      days_of_week = CodetableItem.where("code_table_id = 153").order("id")
      number_of_weeks_to_be_added.to_i.times do
        wpc = ClientCharacteristic.get_work_characteristic_for_client(action_plan_detail.client_id)
          if ActivityHour.get_number_of_weeks_added(@action_plan_detail.id) < @action_plan_detail.get_duration
            activity_hours = ActivityHour.get_activity_hours_for_action_plan_detail(@action_plan_detail.id)
            if activity_hours.present?
                start_date = DateService.date_of_next("Sunday", activity_hours.first.activity_date)
                start_day_id = CodetableItem.where("code_table_id = 153 and short_description = ?",start_date.strftime("%A")).first.id
            else
                start_date = @action_plan_detail.start_date.to_date
                start_day_id = CodetableItem.where("code_table_id = 153 and short_description = ?",start_date.strftime("%A")).first.id
            end#activity_hours.present?
          end #ActivityHour.get_number_of_weeks_added(@action_plan_detail.id)
         days_of_week.each do |day|
            if activity_end_date.to_date >= start_date.to_date
              start_day_id = CodetableItem.where("code_table_id = 153 and short_description = ?",start_date.strftime("%A")).first.id
                if schedule.day_of_week.include?(start_day_id)
                  activity_hour = @action_plan_detail.activity_hours.new
                  activity_hour.client_id = action_plan_detail.client_id
                  activity_hour.activity_date = start_date
                    if wpc.present?
                      activity_hour.work_participation_code = wpc.first.characteristic_id
                    end
                    activity_hour.assigned_hours = @action_plan_detail.hours_per_day
                    if activity_hour.save
                        activity_hour_processed_count = activity_hour_processed_count + 1
                        name = "( program unit id - #{action_plan_detail.program_unit_id} client id -#{action_plan_detail.client_id} and action_plan_detail_id - #{action_plan_detail.action_plan_detail_id}\n"
                        file.write(name)
                    else
                        activity_hour_process_fail_count = activity_hour_process_fail_count + 1
                        error = "This client details failed while inserting record  client_id -#{action_plan_detail.client_id} action_plan_detail_id#{action_plan_detail.action_plan_detail_id}for program unit -#{action_plan_detail.program_unit_id}\n  "
                        error_file.write(error)
                    end#activity_hour.save
                end#schedule.day_of_week.include?(day.id)
                end # END if activity_end_date >= start_date
                start_date = start_date + 1
            end # END days_of_week.each do |day|
      end#number_of_weeks_to_be_added.to_i.times
    end#action_plan_details_collection.each
      file.write("Total clients processed = " + activity_hour_extracted_count.to_s + "\n")
      file.write("Total record inserted activity hour = " + activity_hour_processed_count.to_s + "\n")
      error_file.write("Total record failed to insert records into activity hour = " + activity_hour_process_fail_count.to_s + "\n")
end #task :work_task_creation_for_work_characteristic_from_batch => :environment do
