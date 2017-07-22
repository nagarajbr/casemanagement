namespace :populate_codetable173 do
	desc "Add work task6"
	task :add_work_task6 => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Request to approve career plan",long_description:"Request to approve career plan",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Work on rejected career plan",long_description:"Work on rejected career plan",system_defined:"TRUE",active:"TRUE")
	end
end