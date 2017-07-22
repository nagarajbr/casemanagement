namespace :populate_codetable70 do
	desc "w9-codes"
	task :creating_w9_codes => :environment do

		code_tables = CodeTable.create(name:"w9 codes",description:"w9 codes")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Individual/Sole Proprietorship",long_description:"Individual/Sole Proprietorship",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Partnership",long_description:"Partnership",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Corporation",long_description:"Corporation",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Government entity",long_description:"Government entity",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Other or Non-Profit",long_description:"Other or Non-Profit",system_defined:"FALSE",active:"TRUE")
	end
end