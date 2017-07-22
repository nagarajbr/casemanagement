namespace :populate_codetable61 do
	desc "Program Unit Reinstate Reasons"
	task :reinstate_reasons => :environment do
		code_tables = CodeTable.create(name:"Program Unit Reinstate Reasons",description:"Program Unit Reinstate Reasons")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate LTC-Home Visit",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate-Closed in error",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate-Reporting",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate-Hearing",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate-Correction Only",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate-Ser Prog Change",long_description:" ",system_defined:"FALSE",active:"TRUE")


	end
end