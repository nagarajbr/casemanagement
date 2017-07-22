namespace :populate_codetable100 do
	desc "Outcome Entities "
	task :outcome_entities  => :environment do
		code_table = CodeTable.create(name:"Outcome Entities",description:"Outcome Entities")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Barrier Reduction Plan",long_description:"Barrier Reduction Plan",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Action",long_description:"Action",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Service",long_description:"Service",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Employment Plan",long_description:"Employment Plan",system_defined:"FALSE",active:"TRUE")
	end
end

