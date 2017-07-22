namespace :populate_codetable321 do
	desc "adding new work task type"
	task :adding_new_work_task => :environment do
		CodetableItem.create(code_table_id:18,short_description:"Assessment changed by other user",long_description:"Assessment changed by other user",system_defined:"TRUE",active:"TRUE")
	end
end