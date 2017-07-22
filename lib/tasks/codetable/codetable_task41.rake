namespace :populate_codetable41 do
	desc "Data Validation Items"
	task :add_application_eligibilty_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:129,short_description:"Education is required",long_description:"Education is required",system_defined:"FALSE",active:"TRUE")
	end
end