namespace :populate_codetable103 do
	desc "Action Plan Activity Status Filter"
	task :activity_filter_criteria  => :environment do
		code_table = CodeTable.create(name:"Action Plan Activity Status Filter criteria",description:"Action Plan Activity Status Filter criteria ")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"All",long_description:"",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Open",long_description:"",system_defined:"FALSE",active:"TRUE")

	end
end

