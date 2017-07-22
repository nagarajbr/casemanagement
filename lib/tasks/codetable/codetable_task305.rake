namespace :populate_codetable305 do
	desc "adding_beneficiary_type_household"
	task :adding_beneficiary_type_household => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Household",long_description:"Household",system_defined:"TRUE",active:"TRUE")
	end
end