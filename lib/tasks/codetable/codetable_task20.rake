namespace :populate_codetable20 do
	desc "Parent_relation_types"
	task :Parent_relation_types => :environment do
		code_tables = CodeTable.create(name:"Parent Relation Type",description:"Parent Relation Type -Used in Parent Responsibility page.")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Father",long_description:" ",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Mother",long_description:" ",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Not the Father",long_description:" ",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Absent Father",long_description:" ",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Absent Mother",long_description:" ",system_defined:"TRUE",active:"TRUE")
	end
end