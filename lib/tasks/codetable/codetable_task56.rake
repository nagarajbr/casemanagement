namespace :populate_codetable56 do
	desc "Entity List"
	task :entity_list => :environment do
		code_tables = CodeTable.create(name:"Entity List",description:"Entity List")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Client",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Application",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Program Unit",long_description:" ",system_defined:"FALSE",active:"TRUE")

	end
end