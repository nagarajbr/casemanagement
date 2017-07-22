namespace :populate_codetable63 do
	desc "Add items to action indicator"
	task :add_action_indicator_items => :environment do
		codetableitems = CodetableItem.create(code_table_id:135,short_description:"Hold",long_description:"Hold",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:135,short_description:"Released",long_description:"Released",system_defined:"FALSE",active:"TRUE")
	end
end