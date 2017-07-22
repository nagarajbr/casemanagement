namespace :populate_codetable76 do
	desc "Authorization Status"
	task :authorization_status => :environment do
		code_tables = CodeTable.create(name:"Authorization Status",description:"Authorization Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Pending Authorization",long_description:"Pending Authorization",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Authorized",long_description:"Authorized",system_defined:"FALSE",active:"TRUE")

	end
end