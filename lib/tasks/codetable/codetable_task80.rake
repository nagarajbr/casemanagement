
namespace :populate_codetable80 do
	desc "provider agreement status"
	task :provider_agreement_status => :environment do
		code_tables = CodeTable.create(name:"Provider agreement status",description:"Provider agreement status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Incomplete",long_description:"Incomplete",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Complete",long_description:"Complete",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Approved",long_description:"Approved",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Denied",long_description:"Denied",system_defined:"FALSE",active:"TRUE")
	end
end
