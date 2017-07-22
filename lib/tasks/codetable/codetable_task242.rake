namespace :populate_codetable242 do
	desc "Ownership Types"
	task :ownership_types => :environment do
		code_table_object = CodeTable.create(name:"Ownership Types",description:"Ownership Types")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Eligibility Determination",long_description:"Eligibility Determination",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Assessment",long_description:"Assessment",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"career plan Approval",long_description:"career plan Approval",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Benefit Amount Approval",long_description:"Benefit Amount Approval",system_defined:"TRUE",active:"TRUE")
	end
end