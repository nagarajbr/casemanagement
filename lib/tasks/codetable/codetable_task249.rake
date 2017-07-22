namespace :populate_codetable249 do
	desc "adding work task type"
	task :adding_work_task_type_delete_queue => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Delete Queue",long_description:"Delete records from queue",system_defined:"TRUE",active:"TRUE")
	end
end