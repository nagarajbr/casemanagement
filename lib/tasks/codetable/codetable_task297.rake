namespace :populate_codetable297 do
	desc "adding application queue"
	task :adding_application_queue_and_its_task_type => :environment do
		CodetableItem.create(code_table_id:196,short_description:"Applications Queue",long_description:"Applications Queue",system_defined:"FALSE",active:"TRUE",sort_order: 7)
		CodetableItem.create(code_table_id:18,short_description:"Work on Application Intake",long_description:"Work on Application Intake",system_defined:"FALSE",active:"TRUE")
	end
end