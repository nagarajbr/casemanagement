
# /****                  PROGRAM DESCRIPTION                                  *
#    Possible sanctions should create a task for case manager of a            *
# * . possible sanction                                                       *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 12-04-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                   Create a work task to case manager if     *
# *                                 client is Potentially eligible           *
#                                   for sanction
#
# *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *																			  *
# *  ERROR FILES,LOG FILES         sanction_work_hours, log_sanction_work_hours*
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *****************************************************************************
# Batch should run on 10th of every month
task :sanction_recommended_notify_case_manager => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	filename = "batch_results/monthly/sanction_recommended_notify_case_manager/results/sanction_recommended"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	error_filename = "batch_results/monthly/sanction_recommended_notify_case_manager/results/log_sanction_recommended"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	path = File.join(Rails.root, filename )
	error_path = File.join(Rails.root, error_filename )
	# # Create new file called 'filename.txt' at a specified path.
		file = File.new(path,"w+")
		error_file = File.new(error_path,"w+")
		total_activity_hours_count = 0
		activity_hours_not_met_count = 0
		total_work_task_created_count = 0
		already_work_task_exist = 0
		total_fail_in_work_task_creation_count = 0
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
					ls_action_text = " Potentially eligible for sanction :#{ls_client_name}"
					ls_instructions = "This is a system generated task to case manager to manage possible sanction for program unit :#{each_work_characteristic.id} and Client:#{ls_client_name}"
					if each_work_characteristic.case_manager_id.present?
						assigned_to = each_work_characteristic.case_manager_id
					elsif each_work_characteristic.eligibility_worker_id.present?
						assigned_to = each_work_characteristic.eligibility_worker_id
					end
					l_days_to_complete_task = SystemParam.get_key_value(18,"6716","Number of days to complete Task -Possible sanctions - Days to complete = 10")
		            l_days_to_complete_task = l_days_to_complete_task.to_i
		            ldt_due_date = Date.today + l_days_to_complete_task
			        work_task_for_case_manager = WorkTask.save_work_task(6716,# arg_task_type,
																		6510, # arg_beneficiary_type -program_unit,#6510 - client,
																		each_work_characteristic.client_id, #arg_reference_id program_unit_id,
																		ls_action_text, #arg_action_text,
																		6342, #client,
																		assigned_to, #arg_assigned_to_id,
																		AuditModule.get_current_user,#arg_assigned_by_user_id,
																		6366, #arg_task_category, - client
																		each_work_characteristic.client_id, #arg_client_id
																		ldt_due_date, #arg_due_date
																		ls_instructions, #arg_instructions
																		2188,#arg_urgency,
																		'',#arg_notes,
																		6339, #arg_status
																		each_work_characteristic.id	)
					if work_task_for_case_manager == "NEWRECORD"
						total_work_task_created_count = total_work_task_created_count + 1
						name = " New task for client -  #{ls_client_name}"
						file.write(name + "\n")
					elsif  work_task_for_case_manager == "SUCCESS"
						already_work_task_exist = already_work_task_exist + 1
						name = " client bypassed-  #{ls_client_name}"
						file.write(name + "\n")
					# pending work task already exists - no need to create one more
					else
						total_fail_in_work_task_creation_count = total_fail_in_work_task_creation_count + 1
						error = "unable to create task to case manager to manage current work participation in program unit :#{each_work_characteristic.id} for Client:#{ls_client_name}"
						error_file.write(error + "\n")
					end
				end
			end
		end

		file.write("Total clients activity assigned = " + total_activity_hours_count.to_s + "\n")
		file.write("Total clients who failed to meet there work participation hours = " + activity_hours_not_met_count.to_s + "\n")
		file.write("Total already work task exists  = " + already_work_task_exist.to_s + "\n")
		file.write("Total create work task = " + total_work_task_created_count.to_s + "\n")
		error_file.write("Total failed to create work task = " + total_fail_in_work_task_creation_count.to_s + "\n")


end  #:sanction_recommended_notify_case_manager => :environment do

