namespace :populate_codetable277 do
	desc "adding task type for prescreening"
	task :adding_task_type_for_initiate_application_process => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Prescreening process",long_description:"Prescreening process",system_defined:"TRUE",active:"TRUE")
	end
end