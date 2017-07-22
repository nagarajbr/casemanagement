namespace :populate_codetable15 do
	desc "Budget Calculation Rule"
	task :Budget_Calculation_Rule => :environment do

		code_tables = CodeTable.create(name:"Budget Calculation Rule",description:"Budget Calculation Rule")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Averaged",long_description:"Averaged",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Converted",long_description:"Converted",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Intended Use",long_description:"Intended Use",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Actual",long_description:"Actual for Current/Future Month",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Actual Retro",long_description:"Actual for Retro Month",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Actual-Converted",long_description:"Actual-Conv for Current/Future Month",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Actual-Conv Retro",long_description:"Actual-Conv for Retro Month",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:" ",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end

end