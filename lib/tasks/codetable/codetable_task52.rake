namespace :populate_codetable52 do
	desc "Education Short List"
	task :education_short_list => :environment do
		code_tables = CodeTable.create(name:"Education Short List",description:"Education Short List")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Less than High School",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"High School",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Some College",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"2 year College",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"4 year College",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Post Graduate",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Other",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end