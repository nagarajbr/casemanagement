namespace :populate_codetable324 do
	desc "minor parent education goal added"
	task :minor_parent_education_goal  => :environment do
		code_table = CodeTable.create(name:"Minor Parent Education Plan",description:"Minor Parent Education Plan")
		codetableitems = CodetableItem.create(code_table_id:code_table.id,short_description:"High School Diploma/GED",long_description:"High School Diploma/GED",system_defined:"FALSE",active:"TRUE")

	end
end
