namespace :populate_codetable97 do
	desc "activity_classification_types"
	task :activity_classification_types => :environment do
		code_table = CodeTable.create(name:"Activity Classification Types",description:"Activity Classification Types - Core / Non Core")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Core",long_description:"Core",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"Non Core",long_description:"Non Core",system_defined:"FALSE",active:"TRUE")
	end
end