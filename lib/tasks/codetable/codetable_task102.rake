namespace :populate_codetable102 do
	desc "Action Plan Update Method "
	task :action_plan_update_method  => :environment do
		code_table = CodeTable.create(name:"Action Plan Update Method ",description:"Action Plan Update Method ")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Phone",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Letter",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Person",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end

