
namespace :populate_codetable89 do
	desc "Payment Status"
	task :payment_status => :environment do
		code_tables = CodeTable.create(name:"Payment Status",description:"Payment Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Submitted",long_description:"Submitted",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Sent To AASIS",long_description:"Authorized",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reimbursed",long_description:"Reimbursed - after AASIS creates check for this payment - this status is updated from batch",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Returned",long_description:"Returned",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Re-issued",long_description:"Re-issued",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Cancelled",long_description:"Cancelled",system_defined:"FALSE",active:"TRUE")


	end
end
