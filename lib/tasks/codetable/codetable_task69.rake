namespace :populate_codetable69 do
	desc "provider status"
	task :creating_provider_status => :environment do

		code_tables = CodeTable.create(name:"OLD provider status",description:"provider status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Active",long_description:"Active",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Inactive",long_description:"Inactive",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Unverified",long_description:"Unverified",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Verified",long_description:"Verified",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Pending",long_description:"Pending",system_defined:"FALSE",active:"TRUE")
	end
end