namespace :populate_codetable283 do
	desc "adding Work Task Category"
	task :adding_work_task_category => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Prescreening Household",long_description:"Prescreening Household",system_defined:"FALSE",active:"TRUE")
	end
end