namespace :populate_codetable176 do
	desc "Add work task7"
	task :add_work_task7 => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Request to approve Service Payment",long_description:"Request to approve Service Payment",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"Work on rejected Service Payment",long_description:"Work on rejected Service Payment",system_defined:"TRUE",active:"TRUE")
	end
end