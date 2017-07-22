namespace :populate_codetable24 do
	desc "Application Service Program Groups"
	task :application_service_program_groups => :environment do
		code_tables = CodeTable.create(name:"Application Service Program Groups",description:"Application TANF service program choices -TEA/TEA Diversion and WorkPays/TEA Diversion")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA / TEA Diversion",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"WorkPays / TEA Diversion",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end