namespace :populate_codetable226 do
	desc "adding action type AASIS verification"
	task :adding_task_complete_application_screening => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Complete Application Screening",long_description:"Complete Application Screening",system_defined:"FALSE",active:"TRUE")

	end
end