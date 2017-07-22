namespace :populate_codetable101 do
	desc "Action Plan Types "
	task :action_plan_type  => :environment do
		code_table = CodeTable.create(name:"Action Plan Types ",description:"Action Plan Types ")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Initial",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Update",long_description:"",system_defined:"FALSE",active:"TRUE")
	end
end

