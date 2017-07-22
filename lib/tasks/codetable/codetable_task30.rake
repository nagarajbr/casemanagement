namespace :populate_codetable30 do
	desc "Data Validation Items"
	task :data_validation_items => :environment do
		code_tables = CodeTable.create(name:"Data Validation Items",description:"Data Validation Items")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"SSN is required",long_description:"SSN is required",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Residency information is required",long_description:"Residency information is required",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Date of birth is required",long_description:"Date of birth is required",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Address is required",long_description:"Address is required",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work Registration is required",long_description:"Work Registration is required",system_defined:"FALSE",active:"TRUE")
	end
end