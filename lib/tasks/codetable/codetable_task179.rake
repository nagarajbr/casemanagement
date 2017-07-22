namespace :populate_codetable179 do
	desc "Add work task8"
	task :add_work_task8 => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Request to approve Provider Invoice",long_description:"Request to approve Provider Invoice",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:18,short_description:"work on rejected Provider Invoice",long_description:"work on rejected Provider Invoice",system_defined:"TRUE",active:"TRUE")
	end
end