namespace :populate_codetable25 do
	desc "Application Disposition Status list"
	task :application_disposition_status => :environment do
		code_tables = CodeTable.create(name:"Application Disposition Status List",description:"Application Disposition Status List")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Approved",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Denied",long_description:" ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Registered",long_description:" ",system_defined:"FALSE",active:"TRUE")

	end
end