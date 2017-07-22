namespace :populate_codetable14 do
	desc "add_code"
	task :add_code => :environment do
		code_tables = CodeTable.where("id = 37").first
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Contactual-Hourly",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Contractual - Non Hourly",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Daily",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Hourly",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Piecemeal",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.where("code_table_id = 37").destroy_all
	end
end