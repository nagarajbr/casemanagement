namespace :populate_codetable95 do
	desc "Identified By List"
	task :identified_by_list => :environment do
		code_tables = CodeTable.create(name:"Identified By List",description:"Example : Barriers identified by Agency, Third Party")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Agency",long_description:"Agency",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Third Party",long_description:"Third Party",system_defined:"FALSE",active:"TRUE")
    end
end