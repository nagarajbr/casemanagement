namespace :populate_codetable6 do
	desc "disability_type"
	task :disability_type => :environment do
		code_tables = CodeTable.create(name:"Disability Type",description:"Disability Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Permanent",long_description:"Permanent",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Temporary",long_description:"Temporary",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"MRT",long_description:"MRT",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"None",long_description:"None",system_defined:"TRUE",active:"TRUE")
	end

end