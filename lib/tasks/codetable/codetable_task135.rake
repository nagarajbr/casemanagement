namespace :populate_codetable135 do
	desc " work task approve provider agreement"
	task :work_task_aprv_provider_agrmnt => :environment do
		# "Work Task Category"
		CodetableItem.create(code_table_id:166,short_description:"Provider",long_description:"Provider",system_defined:"FALSE",active:"TRUE")
		# Task Type
		CodetableItem.create(code_table_id:18,short_description:"Approve Provider Agreement",long_description:"Approve Provider Agreement",system_defined:"FALSE",active:"TRUE")
		# beneficiary type = Provider Agreement 162
		CodetableItem.create(code_table_id:162,short_description:"Provider Agreement",long_description:"Provider Agreement",system_defined:"FALSE",active:"TRUE")
    end
end