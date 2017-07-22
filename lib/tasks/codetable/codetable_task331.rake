namespace :populate_codetable331 do
	desc "Work Task 'Other' dropdown  added for providers"
	task :work_task_other_add_for_providers  => :environment do
	user_object = User.find(1)
    AuditModule.set_current_user=(user_object)
	CodetableItem.create(code_table_id:212,short_description:"Other",long_description:"Other",system_defined:"FALSE",active:"TRUE")
	end
end