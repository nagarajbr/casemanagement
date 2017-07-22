namespace :populate_codetable71 do
	desc "provider types"
	task :creating_provider_type_codes => :environment do
		code_tables = CodeTable.create(name:"provider type",description:"provider type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Individual",long_description:"Individual",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Business",long_description:"Business",system_defined:"FALSE",active:"TRUE")
	end
end