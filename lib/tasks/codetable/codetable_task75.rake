namespace :populate_codetable75 do
	desc "address_entity_type"
	task :address_entity_type => :environment do
		code_tables = CodeTable.create(name:"Address Entity Type",description:"Address Entity Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Client",long_description:"Client",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Provider",long_description:"Provider",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Employer",long_description:"Employer",system_defined:"FALSE",active:"TRUE")
	end
end