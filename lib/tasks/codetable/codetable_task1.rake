namespace :populate_codetable1 do
	desc "phone_type_and_state"
	task :phone_type_state => :environment do
		code_tables = CodeTable.create(name:"Phone Type",description:"Phone Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Home",long_description:"Home",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work",long_description:"Work",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Mobile",long_description:"Mobile",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.create(name:"Address Type",description:"Address Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Residence",long_description:"Residence",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Mailing",long_description:"Mailing",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Prior",long_description:"Prior",system_defined:"TRUE",active:"TRUE")
		code_tables = CodeTable.create(name:"State",description:"List of States")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"AR",long_description:"Arkansas",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TX",long_description:"Texas",system_defined:"TRUE",active:"TRUE")
	end

end