require "#{Rails.root}/app/pdfs/core/fillable_pdf_form.rb"
require "#{Rails.root}/lib/tasks/notices/daily/daily_action/source/reeval.rb"

task :re_eval_send => :environment do
	batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
	ls_file_date = Date.today.strftime("%m%d%Y")+ Time.now.strftime("%H%M%S")
	ls_tomorrow = Date.tomorrow.strftime("%Y%m%d").to_s
	ls_extract_month = Date.today.prev_month(5)
	#ls_extract_month = Date.ls_today_month.prev_month(5)
	l_count = 0
	l_error_count = 0
	# no_active_program_unit_queue = 0
	move_to_queue = 0
	failed_to_move_to_queue = 0
	no_primary_contact = 0
	# no_records_to_process = 0
	# l_work_task_count = 0
	# l_work_task_fail_count = 0


	# filename = "lib/tasks/batch/Monthly/reeval/results/reeval_" + ls_file_date.to_s + ".txt"
	log_filename = "batch_results/monthly/reeval/results/reeval_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

	# path = File.join(Rails.root, filename )
	log_path = File.join(Rails.root, log_filename )

	# Create new file at a specified path.
	# file = File.new(path,"w+")
	log_file = File.new(log_path,"w+")

	# ls_extract_date = Date.today.strftime("%Y-%m-%d")
	log_file.puts("Begin Reeval batch process:  #{Date.today.strftime("%m/%d/%Y")}  #{Time.now.strftime("%H:%M:%S")}")
	# log_file.puts("Extract date: " + ls_extract_date.to_s)
	# log_file.puts('Available Date: ' + ls_tomorrow)

	# re_eval_collection = ProgramUnit.get_list_of_program_units_to_be_re_evaluated
	 step1 = ProgramUnit.joins("INNER JOIN program_unit_members ON (program_unit_members.program_unit_id = program_units.id)
                     INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
                                               AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID) FROM PROGRAM_UNIT_PARTICIPATIONS A WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID)
                                               AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
                                               )")
      #step2 = step1.where("(program_units.case_type in (6048,6049) and program_units.service_program_id = 1) or
      step2 = step1.where("((program_units.service_program_id = 1) or
                (program_units.service_program_id = 4)) and (program_units.reeval_date is not null and
                 (Extract(month from program_units.reeval_date) = ?
                  and  Extract(year from program_units.reeval_date) = ? )
                  )",ls_extract_month.month,ls_extract_month.year)
      step3 = step2.select("distinct program_units.*")
      re_eval_collection = step3
Rails.logger.debug("re_eval_collection = #{re_eval_collection.inspect}")
    number_of_records_extracted = re_eval_collection.length
    log_file.puts("Number of records extracted: #{number_of_records_extracted}")
    if re_eval_collection.present?
      	re_eval_collection.each do |re_eval|
      		 primary_member_of_program_unit = PrimaryContact.get_primary_contact(re_eval.id, 6345)
      		if primary_member_of_program_unit.present?
      		 	if WorkQueue.is_queue_record_needed?(6615,6345,re_eval.id) == true
      			  queue_object = WorkQueue.new
	              queue_object.reference_type = 6345
	              queue_object.reference_id = re_eval.id
	              queue_object.state = 6615 # 6642 - "Reevaluation Queue"
	              begin
	                  if queue_object.save!
	                  move_to_queue = move_to_queue + 1
	                  else
	                  	failed_to_move_to_queue = failed_to_move_to_queue + 1
	                  end
	              end
      		    end
      		else
      			no_primary_contact = no_primary_contact + 1
      		end
      	end
    else
        log_file.puts("No program units to process ")
    end
    log_file.puts("no primary contact : #{no_primary_contact}")
	log_file.puts("Move to reevaluation queue : #{move_to_queue}")
	log_file.puts("Failed to move to reevaluation queue: #{failed_to_move_to_queue}")
	log_file.puts("Number of notices created: #{l_count}")
	log_file.puts("Number of records with insufficient data to create a notice: #{l_error_count}")
	log_file.puts("End Reeval batch process:  #{Date.today.strftime("%m/%d/%Y")}  #{Time.now.strftime("%H:%M:%S")}")

end