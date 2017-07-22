namespace :populate_codetable96 do
	desc "creating_payment_types"
	task :creating_payment_types => :environment do
		code_tables = CodeTable.create(name:"Payment Types",description:"Payment Types")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Supplement",long_description:"Supplement",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Retro",long_description:"Retro",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"First Month Bonus",long_description:"First Month Bonus",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Second Month Bonus",long_description:"Second Month Bonus",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Third Month Bonus",long_description:"Third Month Bonus",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Exit",long_description:"Exit",system_defined:"FALSE",active:"TRUE")
	end
end