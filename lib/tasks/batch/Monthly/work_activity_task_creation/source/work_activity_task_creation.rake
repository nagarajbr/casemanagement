
# /****                  PROGRAM DESCRIPTION                                  *
# * Task should be created to the case manage when activity duration is compledte *
# * and activity is not  extend or close.                                                        *
# *                                                                           *
# * .                                                                         *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 12-16-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                   create a work task to case worker        *
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
# *  RECOVERY  INSTRUCTIONS        Re run the program                                                                             *
# *                                                                           *
# *****************************************************************************
task :work_activity_task_creation => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	filename = "batch_results/monthly/work_activity_task_creation/results/task_created" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	error_filename = "batch_results/monthly/work_activity_task_creation/results/task_creation_error" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	path = File.join(Rails.root, filename )
	error_path = File.join(Rails.root, error_filename )
	# # Create new file called 'filename.txt' at a specified path.
	file = File.new(path,"w+")
	error_file = File.new(error_path,"w+")
	total_activity_hours_count = 0
	total_activity_hours_processed_count = 0
	total_activity_hours_process_fail_count = 0
	end_of_current_month = Date.today.end_of_month # end of the month

	 step1 = ProgramUnit.joins("inner join action_plans on action_plans.program_unit_id = program_units.id
                               inner join action_plan_details  on action_plan_details.action_plan_id = action_plans.id ")
    step2 = step1.where("action_plan_details.end_date is  null and action_plan_details.start_date <= ?",end_of_current_month)
    step3 = step2.select("action_plan_details.id as action_plan_detail_id , action_plans.client_id, program_units.id as program_unit_id,program_units.case_manager_id,program_units.eligibility_worker_id,action_plan_details.start_date as action_plan_detail_start_date")

     action_plan_details_collection = step3
     total_activity_hours_count = action_plan_details_collection.length
     action_plan_details_collection.each do |action_plan_detail|
	  @action_plan_detail = ActionPlanDetail.find(action_plan_detail.action_plan_detail_id)
	  start_of_current_month = @action_plan_detail.start_date #start of activity
	  schedule = Schedule.get_schedule_for_action_plan_detail(@action_plan_detail.id)
	  number_of_weeks_assigned =  Schedule.get_duration_for_action_plan_detail(@action_plan_detail.id)
	  start_date = @action_plan_detail.start_date
	  end_of_activity = start_date + (number_of_weeks_assigned.present? ? (number_of_weeks_assigned.to_i).weeks : 0)
	 if (start_of_current_month..end_of_current_month).include?(end_of_activity)
	  	# activity ended in current month no action is take
		  	assigned_to = nil
		   	if action_plan_detail.case_manager_id.present?
		   	   assigned_to = action_plan_detail.case_manager_id
		   	elsif action_plan_detail.eligibility_worker_id.present?
		   		assigned_to = action_plan_detail.eligibility_worker_id
		   	end
		   	ls_client_name = Client.get_client_full_name_from_client_id(action_plan_detail.client_id)
		   	ls_action_text = " Manage activity :#{ls_client_name}"
            ls_instructions = "This is a system generated task to case manager to manage activity: #{CodetableItem.get_short_description(@action_plan_detail.activity_type)} program unit :#{action_plan_detail.program_unit_id} for Client:#{ls_client_name}"
            l_days_to_complete_task = SystemParam.get_key_value(18,"2140","Number of days to complete Task - 'Work on Sanction Task-Days to complete = 10'")
            l_days_to_complete_task = l_days_to_complete_task.to_i
            ldt_due_date = Date.today + l_days_to_complete_task
		   	if assigned_to.present? and action_plan_detail.program_unit_id.present? and action_plan_detail.client_id.present?
			  	work_task_for_case_manager = WorkTask.save_work_task(2140,# arg_task_type,
		   			                                                 6727, # arg_beneficiary_type -"Action plan detail"
		   			                                                 action_plan_detail.action_plan_detail_id, #arg_reference_id "Action plan detail id
		   			                                                 ls_action_text, #arg_action_text,
		   			                                                 6342, #client,
		   			                                                 assigned_to, #arg_assigned_to_id,
		   			                                                 batch_user.uid,#arg_assigned_by_user_id,
		   			                                                 6366, #arg_task_category, - client
		   			                                                 action_plan_detail.client_id, #arg_client_id
		   			                                                 ldt_due_date, #arg_due_date
		   			                                                 ls_instructions, #arg_instructions
		   			                                                 2188,#arg_urgency,
				                                                     '',#arg_notes,
				                                                     6339, #arg_status
				                                                     action_plan_detail.program_unit_id )
				if work_task_for_case_manager == "NEWRECORD"
					total_activity_hours_processed_count = total_activity_hours_processed_count + 1
			   		name = " client name -  #{ls_client_name}"
			        file.write(name + "\n")

				elsif  work_task_for_case_manager == "SUCCESS"
					# pending work task already exists - no need to create one more
				else
                     total_activity_hours_process_fail_count = total_activity_hours_process_fail_count + 1
					 error = "unable to create task to case manager to manage current work characteristic in program unit :#{action_plan_detail.id} for Client:#{ls_client_name}"
					 error_file.write(error + "\n")
				end

		   	else
				unless assigned_to.present?
				    total_activity_hours_process_fail_count = total_activity_hours_process_fail_count + 1
					error = "unable to get case manager - #{assigned_to}"
					error_file.write(error + "\n")
				end#assigned_to.present?
				unless action_plan_detail.program_unit_id.present?
					total_activity_hours_process_fail_count = total_activity_hours_process_fail_count + 1
					error = "unable to get program unit- #{action_plan_detail.program_unit_id}"
					error_file.write(error + "\n")
				end#action_plan_detail.program_unit_id.present?
				unless action_plan_detail.client_id.present?
					total_activity_hours_process_fail_count = total_activity_hours_process_fail_count + 1
					error = "unable to get client- #{action_plan_detail.client_id}"
					error_file.write(error + "\n")
				end#action_plan_detail.client_id.present?

		   	end
	    end


	end

	file.write("Total activity hours extracted = " + total_activity_hours_count.to_s + "\n")
	file.write("Total activity hours processed = " + total_activity_hours_processed_count.to_s + "\n")
	file.write("Total activity hours failed to process = " + total_activity_hours_process_fail_count.to_s + "\n")

end #task :work_activity_task_creation => :environment do

