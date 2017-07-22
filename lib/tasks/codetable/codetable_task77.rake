namespace :populate_codetable77 do
	desc "Provider Status"
	task :provider_status => :environment do
		code_tables = CodeTable.create(name:"Provider Status",description:"Provider Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Pending",long_description:"Pending Status records will be sent to AASIS for verification",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"AASIS Verified",long_description:"Verified by AASIS",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Inactive",long_description:"Inactive",system_defined:"FALSE",active:"TRUE")

	end
end