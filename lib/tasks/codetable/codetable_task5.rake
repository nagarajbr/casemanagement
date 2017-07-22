namespace :populate_codetable5 do
	desc "payment_type"
	task :payment_type => :environment do
		code_tables = CodeTable.create(name:"Payment Type",description:"Payment Type")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Regular",long_description:"Permanent",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Supplement",long_description:"Temporary",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Bonus",long_description:"TEA Bonus",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"TEA Transportation",long_description:"TEA Transportation",system_defined:"TRUE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Work-pays Bonus",long_description:"Work-pays Bonus",system_defined:"TRUE",active:"TRUE")
	end
end