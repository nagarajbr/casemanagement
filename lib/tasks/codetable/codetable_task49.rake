namespace :populate_codetable49 do
	desc "cleanup task"
	task :delete_update_questions => :environment do
		# Manoj 10/20/2014
		# code table 141 is not needed.
		CodetableItem.where("code_table_id = 141").destroy_all
		# remove code table entry also
		CodeTable.where("id = 141").destroy_all

		CodetableItem.where("id = 6074 and code_table_id = 137").destroy_all

		CodetableItem.where("id = 6061 and code_table_id = 137").update_all(short_description:"Looking for a job")
		CodetableItem.where("id = 6073 and code_table_id = 137").update_all(short_description:"Working, but wants a better job")
		CodetableItem.where("id = 6062 and code_table_id = 137").update_all(short_description:"Recently unemployed")
		CodetableItem.where("id = 6063 and code_table_id = 137").update_all(short_description:"Unemployed for a year or longer")
		CodetableItem.where("id = 6064 and code_table_id = 137").update_all(short_description:"Unemployed due to recent company closure")
		CodetableItem.where("id = 6065 and code_table_id = 137").update_all(short_description:"Unemployed due to their job being outsourced")
		CodetableItem.where("id = 6067 and code_table_id = 139").update_all(short_description:"Disabled")
		CodetableItem.where("id = 6068 and code_table_id = 140").update_all(short_description:"A veteran")
		CodetableItem.where("id = 6066 and code_table_id = 138").destroy_all
		CodeTable.where("id = 138").destroy_all
		code_tables = CodeTable.create(name:"PreScreening Questions-Housing_utilities",description:"PreScreening Questions-Housing_utilities")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Do you need help in paying for your housing utilities?",long_description:"",system_defined:"FALSE",active:"TRUE")













	end
end