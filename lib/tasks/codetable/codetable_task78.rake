namespace :populate_codetable78 do
	desc "Unit Of Measure"
	task :unit_of_measure => :environment do
		code_tables = CodeTable.create(name:"Unit Of Measure",description:"Unit Of Measure")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Miles",long_description:"Miles",system_defined:"FALSE",active:"TRUE")
		codetableitems = CodetableItem.create(code_table_id:code_tables.id,short_description:"Hours",long_description:"Hours",system_defined:"FALSE",active:"TRUE")

	end
end