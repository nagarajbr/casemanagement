namespace :populate_codetable51 do
	desc "Parent Status"
	task :parent_status_list => :environment do
		code_tables = CodeTable.create(name:"Parent Status",description:"Parent Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Absent",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Present",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end