
# /****                  PROGRAM DESCRIPTION                                  *
# * Delete eligibility runs that are no longer required -30days prior to current date*
# * .                                                                         *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *																			  *
# *  DATE OF WRITTEN     : 10-08-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:    Delete eligibility runs that are no longer required      *
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

task :delete_eligibility_runs => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	filename = "batch_results/monthly/delete_eligibility_runs/results/task_created"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	error_filename = "batch_results/monthly/delete_eligibility_runs/results/task_creation_error"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
	path = File.join(Rails.root, filename )
	error_path = File.join(Rails.root, error_filename )
	# # Create new file called 'filename.txt' at a specified path.
		file = File.new(path,"w+")
		error_file = File.new(error_path,"w+")
		total_extracted_count = 0
		total_processed_count = 0
		total_process_fail_count = 0
		date =Date.today - 30.days
		eligibility_run_collection = ProgramWizard.where("submit_date is null
			                                               and retain_ind is null
			                                               and selected_for_planning is null
			                                               and date(created_at) < ?
			                                            ",date)

		if eligibility_run_collection.present?
			total_extracted_count = eligibility_run_collection.length
			 eligibility_run_collection.each do |each_run_id|
			 	pw_id = each_run_id.id
			 	pw_program_unit_id = each_run_id.program_unit_id
               if each_run_id.destroy
	            	total_processed_count = total_processed_count + 1
			   		name = "Program wizard id:#{pw_id} and program unit id: #{pw_program_unit_id}"
			        file.write(name + "\n")
               else
               	    total_process_fail_count = total_process_fail_count + 1
					 error = "Program wizard id:#{pw_id}and program unit id: #{pw_program_unit_id}"
					 error_file.write(error + "\n")
               end

			 end

	    end

		file.write("Total extracted = " + total_extracted_count.to_s + "\n")
		file.write("Total processed = " + total_processed_count.to_s + "\n")
		file.write("Total failed to process = " + total_process_fail_count.to_s + "\n")

end  #:work_pays_monthly_payments_from_batch => :environment do

