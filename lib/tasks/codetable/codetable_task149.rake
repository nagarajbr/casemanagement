namespace :populate_codetable149 do
	desc "Work Flow Status"
	task :work_flow_status => :environment do
		code_table = CodeTable.create(name:"Work Flow Status",description:"Work Flow Status - Requested/Approved/Rejected")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Requested",long_description:"Requested",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Approved",long_description:"Approved",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table.id,short_description:"Rejected",long_description:"Rejected",system_defined:"FALSE",active:"TRUE")
	end
end