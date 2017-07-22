namespace :populate_codetable34 do
	desc "Application Eligibility Results"
	task :application_eligibilty_items => :environment do
		code_tables = CodeTable.create(name:"Application Eligibilty Items",description:"Application Eligibilty Items")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Immunization requirement",long_description:"Immunization requirement",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Education requirement",long_description:"Education requirement",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Deprivation requirement",long_description:"Deprivation requirement",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work Participation requirement",long_description:"Work Participation requirement",system_defined:"FALSE",active:"TRUE")
	end
end