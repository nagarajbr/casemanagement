namespace :populate_codetable74 do
	desc "service types"
	task :provider_service_type => :environment do
		code_tables = CodeTable.create(name:"provider service types",description:"provider service types")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Transportation",long_description:"Transportation",system_defined:"FALSE",active:"TRUE")
	end
end