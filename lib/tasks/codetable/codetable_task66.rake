namespace :populate_codetable66 do
	desc "Data Validation Items"
	task :add_application_eligibilty_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"TEA State Time Limits have been met",long_description:"Client has reached maximum TEA state time limits",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Federal Time Limits have been met",long_description:"Client has reached maximum federal time limits",system_defined:"FALSE",active:"TRUE")
	end
end