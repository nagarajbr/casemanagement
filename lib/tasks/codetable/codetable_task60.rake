namespace :populate_codetable60 do
	desc "Program Unit Actions"
	task :program_unit_actions => :environment do
		code_tables = CodeTable.create(name:"Program Unit Actions",description:"Program Unit Actions")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Deny",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Close",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reinstate",long_description:" ",system_defined:"FALSE",active:"TRUE")

	end
end