namespace :populate_codetable160 do
	desc "additional work task types "
	task :additional_work_task_type_rejection => :environment do

		CodetableItem.create(code_table_id:18,short_description:"Service payment line item rejection",long_description:"When Request to approve Service payment line item is rejected by supervisor, this task type is used to send task to case manager to work on rejection.",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Provider invoice rejection",long_description:"When Request to authorize provider Invoice is rejected by supervisor, this task type is used to send task to case manager to work on rejection.",system_defined:"FALSE",active:"TRUE")


	end
end