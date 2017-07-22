namespace :populate_codetable130 do
	desc "addition task type to complete and activate Program Unit"
	task :additional_task_type_complete_pgu => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Complete and Activate New Program Unit",long_description:"Complete and Activate New Program Unit",system_defined:"TRUE",active:"TRUE")
    end
end