namespace :populate_codetable218 do
	desc "adding wage and ui, client deactivation entries to action list"
	task :adding_action_list => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Wage and UI",long_description:"Wage and UI",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:192,short_description:"Client Deactivate",long_description:"Client Deactivate",system_defined:"TRUE",active:"TRUE")
	end
end