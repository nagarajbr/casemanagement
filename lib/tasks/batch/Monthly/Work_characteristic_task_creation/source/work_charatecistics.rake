
# /****                  PROGRAM DESCRIPTION                                  *
# * A follow up task for work characteristic with end date should be created  *
# *  for case workers                                                         *
# *                                                                           *
# * .                                                                         *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *
# *  DATE OF WRITTEN     : 10-08-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                    create a work task to case worker        *
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
task :work_task_creation_for_work_characteristic_from_batch => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	filename = "batch_results/monthly/Work_characteristic_task_creation/results/task_created" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	error_filename = "batch_results/monthly/Work_characteristic_task_creation/results/task_creation_error" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	path = File.join(Rails.root, filename )
	error_path = File.join(Rails.root, error_filename )
	# # Create new file called 'filename.txt' at a specified path.
	file = File.new(path,"w+")
	error_file = File.new(error_path,"w+")
	total_extracted_count = 0
	total_processed_count = 0
	total_process_fail_count = 0
	work_task_already_exits = 0
	month_start_date = nil
    month_end_date = nil
    a = Date.today
    month_start_date = a.beginning_of_month
    month_end_date = a.end_of_month
    step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON( program_unit_members.program_unit_id=program_units.id
                                                        AND program_unit_members.MEMBER_STATUS = 4468
                                                       )
                    INNER JOIN program_unit_participations ON(program_units.id = program_unit_participations.program_unit_id
                                                              and program_unit_participations.id = (SELECT max(a.id)
                                                                                                    FROM program_unit_participations as a
                                                                                                    where a.program_unit_id = program_units.id )
                                                                                                          and program_unit_participations.participation_status = 6043
                                                             )
                   INNER JOIN client_characteristics on(program_unit_members.client_id = client_characteristics.client_id
                                                        AND client_characteristics.characteristic_type= 'WorkCharacteristic'
                                                         AND client_characteristics.id = (select client_characteristics.id
                                                                                          FROM client_characteristics
                                                                                          WHERE client_characteristics.client_id = program_unit_members.client_id
                                                                                          order by client_characteristics.start_date desc limit 1
                                                                                          )
                                                        )
                   ")
    step2 = step1.where("client_characteristics.end_date between ? and ?  or (client_characteristics.end_date is null and client_characteristics.characteristic_id not in (5667,5700,5701)) ",month_start_date ,month_end_date )

    step3 = step2.select("client_characteristics.id as client_characteristics_id, program_unit_members.client_id,program_units.eligibility_worker_id,client_characteristics.end_date,program_units.id,program_units.eligibility_worker_id,program_units.case_manager_id")
	work_characteristic = step3
	if work_characteristic.present?
		total_extracted_count = work_characteristic.length
	   work_characteristic.each do |each_client|

		   	assigned_to = nil
		   	if each_client.case_manager_id.present?
		   	   assigned_to = each_client.case_manager_id
		   	elsif each_client.eligibility_worker_id.present?
		   		assigned_to = each_client.eligibility_worker_id
		   	end
		   	ls_client_name = Client.get_client_full_name_from_client_id(each_client.client_id)
		   	ls_action_text = " Manage work characteristic for client :#{ls_client_name}"
            ls_instructions = "This is a system generated task to case manager to manage current work characteristic in program unit :#{each_client.id} for Client:#{ls_client_name}"
            today = Date.today
            ldt_due_date = today.end_of_month
		   	if assigned_to.present? and each_client.id.present? and each_client.client_id.present?
		   		#work_task_for_case_manager = WorkTask.save_work_task(arg_task_type,arg_beneficiary_type,arg_reference_id,arg_action_text,arg_assigned_to_type,arg_assigned_to_id,arg_assigned_by_user_id,arg_task_category,arg_client_id,arg_due_date,arg_instructions,arg_urgency,arg_notes,arg_status)
		   		# WorkTask.where("task_type = ?
       #                          and beneficiary_type = ?
       #                          and reference_id = ?
       #                          and action_text = ?
       #                          and status = 6339",arg_task_type,
       #                           arg_beneficiary_type,
       #                           arg_reference_id,
       #                           arg_action_text)
		   		work_task_for_case_manager = WorkTask.save_work_task(6530,# arg_task_type,
		   			                                                 6781, # arg_beneficiary_type -program_unit,#6510 - client,
		   			                                                 each_client.client_characteristics_id, #arg_reference_id program_unit_id,
		   			                                                 ls_action_text, #arg_action_text,
		   			                                                 6342, #client,
		   			                                                 assigned_to, #arg_assigned_to_id,
		   			                                                 batch_user.uid,#arg_assigned_by_user_id,
		   			                                                 6366, #arg_task_category, - client
		   			                                                 each_client.client_id, #arg_client_id
		   			                                                 ldt_due_date, #arg_due_date
		   			                                                 ls_instructions, #arg_instructions
		   			                                                 2188,#arg_urgency,
				                                                     '',#arg_notes,
				                                                     6339, #arg_status
				                                                     each_client.id)
					if work_task_for_case_manager == "NEWRECORD"
						total_processed_count = total_processed_count + 1
				   		name = " client name -  #{ls_client_name}"
				        file.write(name + "\n")

					elsif  work_task_for_case_manager == "SUCCESS"
						name = " client name -  #{ls_client_name} already exists."
						file.write(name + "\n")
						work_task_already_exits = work_task_already_exits + 1
						# pending work task already exists - no need to create one more
					else
                         total_process_fail_count = total_process_fail_count + 1
						 error = "unable to create task to case manager to manage current work characteristic in program unit :#{each_client.id} for Client:#{ls_client_name}"
						 error_file.write(error + "\n")
					end


		   	else
				unless assigned_to.present?
				    total_notices_process_fail_count = total_notices_process_fail_count + 1
					error = "unable to get case manager - #{assigned_to}"
					error_file.write(error + "\n")
				end#assigned_to.present?
				unless each_client.id.present?
					total_notices_process_fail_count = total_notices_process_fail_count + 1
					error = "unable to get program unit- #{each_client.id}"
					error_file.write(error + "\n")
				end#each_client.id.present?
				unless each_client.client_id.present?
					total_notices_process_fail_count = total_notices_process_fail_count + 1
					error = "unable to get client- #{each_client.client_id}"
					error_file.write(error + "\n")
				end#each_client.client_id.present?

		   	end
	    end


	end

	file.write("Total client extracted = " + total_extracted_count.to_s + "\n")
	file.write("Total clients processed created a work task  = " + total_processed_count.to_s + "\n")
	file.write("Total clients work task already exits  = " + work_task_already_exits.to_s + "\n")
	file.write("Total clients failed to created a work task = " + total_process_fail_count.to_s + "\n")

end #task :work_task_creation_for_work_characteristic_from_batch => :environment do

