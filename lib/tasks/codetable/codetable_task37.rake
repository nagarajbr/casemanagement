namespace :populate_codetable37 do
	desc "Program Unit Participation Status"
	task :program_unit_participation_status => :environment do
		code_tables = CodeTable.create(name:"Program Unit Participation Status",description:"Program Unit Participation Status")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Open",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Close",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end