namespace :populate_codetable314 do
	desc "Local office city"
	task :local_office_information_added  => :environment do
		codetableitems = CodetableItem.create(code_table_id:2,short_description:"Clarksville",long_description:"Clarksville",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:2,short_description:"Danville",long_description:"Danville",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:2,short_description:"Dumas",long_description:"Dumas",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:2,short_description:"Siloam Springs",long_description:"Siloam Springs",system_defined:"FALSE",active:"TRUE")
	end
end
