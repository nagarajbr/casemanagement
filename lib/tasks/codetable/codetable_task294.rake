namespace :populate_codetable294 do
	desc "Living Arrangement Status"
	task :living_arrangement_status => :environment do
		code_tables = CodeTable.create(name:"Living Arrangement",description:"Living Arrangement")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Subsidized Housing",long_description:"Subsidized Housing",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Foster Care",long_description:"Foster Care",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Homeless",long_description:"Homeless",system_defined:"FALSE",active:"TRUE")
	end
end