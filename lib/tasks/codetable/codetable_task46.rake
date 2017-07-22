namespace :populate_codetable46 do
	# Manoj 10/17/2014
	# Prescreen questions categorised by Employment,Housing_utilities,Disability,Veteran_status
	desc "prescreen_questions"
	task :prescreen_questions => :environment do
		code_tables = CodeTable.create(name:"PreScreening Questions-Employment",description:"Employment PreScreening Questions")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Anybody in the house jobseeker?",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Anybody in the house is unemployed recently?",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Anybody in the house is long term unemployed?",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Anybody in the house is unemployed due to company closure recently?",long_description:"",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Anybody in the house is unemployed due to outsourced job?",long_description:"",system_defined:"FALSE",active:"TRUE")
		# Housing-utilities
		code_tables = CodeTable.create(name:"PreScreening Questions-Housing_utilities",description:"Housing_utilities PreScreening Questions")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Do you need help with payment of housing utilities?",long_description:"",system_defined:"FALSE",active:"TRUE")

		# Disability
		code_tables = CodeTable.create(name:"PreScreening Questions-Disability",description:"Disability PreScreening Questions")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Any member in the house is disabled?",long_description:"",system_defined:"FALSE",active:"TRUE")

		# Veteran
		code_tables = CodeTable.create(name:"PreScreening Questions-Veteran",description:"Veteran PreScreening Questions")
		CodetableItem.create(code_table_id:code_tables.id,short_description:"Any member in the house is a Veteran?",long_description:"",system_defined:"FALSE",active:"TRUE")

	end

end