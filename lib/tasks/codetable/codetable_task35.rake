namespace :populate_codetable35 do
	desc "Client notes"
	task :client_notes => :environment do
		code_tables = CodeTable.create(name:"Client notes",description:"Client notes")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Phone notes",long_description:"Phone notes",system_defined:"FALSE",active:"TRUE")
	end
end