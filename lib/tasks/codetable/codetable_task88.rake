
namespace :populate_codetable88 do
	desc "Provider Invoice Status"
	task :provider_invoice_status => :environment do
		code_tables = CodeTable.create(name:"Provider Invoice Status",description:"Provider Invoice Status")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Submitted",long_description:"Submitted",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Authorized",long_description:"Authorized",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Reimbursed",long_description:"Reimbursed",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Returned",long_description:"Returned",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Re-issued",long_description:"Re-issued",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Cancelled",long_description:"Reimbursed - after AASIS creates check for this payment - this status is updated from batch",system_defined:"FALSE",active:"TRUE")

		# Service Authorization Line Items  status
		codetableitems = CodetableItem.create(code_table_id:161,short_description:"Returned",long_description:"Returned",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:161,short_description:"Re-issued",long_description:"Re-issued",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:161,short_description:"Cancelled",long_description:"Re-issued",system_defined:"FALSE",active:"TRUE")
	end
end
