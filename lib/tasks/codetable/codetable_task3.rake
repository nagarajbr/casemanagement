namespace :codetable_task3 do
	desc "School Type to School Name dropdown"
	task :data_setup => :environment do
		#school type STI
		CodetableItem.where(code_table_id: 21).update_all(type:"SchoolType")
		#  Accessing connection object of Model all SQL queries can be run.
		CodetableItem.connection.execute("update codetable_items set parent_id = id where code_table_id = 21")
		#school names STI
		CodetableItem.where("code_table_id in (62,105,106,107,108,109,110,111)").update_all(type:"SchoolName")
		#Elementary school
		CodetableItem.where("type = 'SchoolName' and code_table_id = 62").update_all(parent_id: 2192)
		#"Middle Schools"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 105").update_all(parent_id: 2193)
		#"High Schools"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 106").update_all(parent_id: 2194)
		#"Colleges"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 107").update_all(parent_id: 2195)
		#"Universities"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 108").update_all(parent_id: 2196)
		#"Trade/Tech Schools"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 109").update_all(parent_id: 2197)
		#"Preschools"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 110").update_all(parent_id: 2199)
		#"Junior High Schools"
		CodetableItem.where("type = 'SchoolName' and code_table_id = 111").update_all(parent_id: 2200)
		#parent type should be CodetableItem
		CodetableItem.where("type = 'SchoolName'").update_all(parent_type: 'CodetableItem')
	end
end