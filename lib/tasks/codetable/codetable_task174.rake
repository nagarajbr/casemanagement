namespace :populate_codetable174 do
	desc " work task beneficiary type - Career Pathway Plan"
	task :work_task_beneficiary_type_cpp => :environment do
		# work task beneficiary type = Career Pathway Plan
		CodetableItem.create(code_table_id:162,short_description:"Career Plan",long_description:"Career Plan",system_defined:"FALSE",active:"TRUE")
    end
end