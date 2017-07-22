namespace :populate_codetable44 do
	desc "creating_payment_action_types"
	task :creating_payment_action_types => :environment do

		code_tables = CodeTable.create(name:"Payment Action Types",description:"Payment Action Types")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Cancel",long_description:"Cancel",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Return",long_description:"Return",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Duplicate",long_description:"Duplicate",system_defined:"FALSE",active:"TRUE")
	end
end