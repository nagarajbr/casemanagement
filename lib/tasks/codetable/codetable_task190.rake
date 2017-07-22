namespace :populate_codetable190 do
	desc "Night Batch table and its process types"
	task :creating_nightly_batch_codetable => :environment do
		code_table_object = CodeTable.create(name:"Nightly Batch Table",description:"Process Type Entries")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"SSN Enumeration",long_description:"SSN Enumeration",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Citizenship",long_description:"Citizenship",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"OCSE",long_description:"OCSE",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"EBT",long_description:"EBT",system_defined:"TRUE",active:"TRUE")
	end
end