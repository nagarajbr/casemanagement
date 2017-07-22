namespace :populate_codetable45 do
	desc "add_title_code"
	task :add_title_code => :environment do
		code_tables = CodeTable.create(name:"Title",description:"Title")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Miss",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Mr",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Ms",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Mrs",long_description:"",system_defined:"FALSE",active:"TRUE")
	end

end