namespace :populate_codetable79 do
	desc "Service Authorization Status"
	task :service_authorization_status => :environment do
		code_tables = CodeTable.create(name:"Service Authorization Status",description:"Service Authorization Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Incomplete",long_description:"Incomplete",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Complete",long_description:"Complete",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Authorized",long_description:"Authorized",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Paid",long_description:"Paid",system_defined:"FALSE",active:"TRUE")

	end
end