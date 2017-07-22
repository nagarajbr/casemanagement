
namespace :populate_codetable82 do
	desc "Service Authorization Line Items Status"
	task :srvc_line_item_status => :environment do
		code_tables = CodeTable.create(name:"Service Authorization Line Items Status",description:"Service Authorization Line Items Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Submitted",long_description:"Submitted",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Authorized",long_description:"After external provider submits his invoice & user authorizes ",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Processed",long_description:" This line item is part of Provider Invoice",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reimbursed",long_description:"Reimbursed - after AASIS creates check for this payment - this status is updated from batch",system_defined:"FALSE",active:"TRUE")


	end
end
