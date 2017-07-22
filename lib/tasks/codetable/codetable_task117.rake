namespace :populate_codetable117 do
	desc "Data Validation Items"
	task :add_application_eligibilty_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:130,short_description:"Receiving SSI",long_description:"Receiving SSI",system_defined:"FALSE",active:"TRUE")
	end
end