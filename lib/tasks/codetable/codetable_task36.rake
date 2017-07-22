namespace :populate_codetable36 do
	desc "Program Unit Disposition Status"
	task :program_unit_disposition_status => :environment do
		code_tables = CodeTable.create(name:"Program Unit Disposition Status",description:"Program Unit Disposition Status")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Determine Eligibility",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Deny",long_description:" ",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Approve",long_description:" ",system_defined:"FALSE",active:"TRUE")
	end
end