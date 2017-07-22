namespace :populate_codetable39 do
	desc "Case Type List"
	task :case_type_list => :environment do
		code_tables = CodeTable.create(name:"Case Type",description:"Case Type ")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Single Parent",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Two Parent",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Child Only",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Minor Parent",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end