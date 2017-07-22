namespace :populate_codetable121 do
	desc "Data Validation Items - workpays"
	task :add_error_message_workpays => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"No income due to earnings with minimum 24 hours a week.",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end