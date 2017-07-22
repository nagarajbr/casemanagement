namespace :populate_codetable53 do
	desc "Data Validation Items"
	task :add_application_eligibilty_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Violations check",long_description:"Violations check",system_defined:"FALSE",active:"TRUE")
	end
end