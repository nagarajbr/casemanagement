namespace :populate_codetable139 do
	desc "SS becoming Service Types"
	task :ss_to_service_types => :environment do
		CodetableItem.create(code_table_id:182,short_description:"Vehicle Insurance",long_description:"Vehicle Insurance",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Vehicle Repairs",long_description:"Vehicle Repairs",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Vehicle Down Payment",long_description:"Vehicle Down Payment",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:182,short_description:"Vehicle Tax/License",long_description:"Vehicle Tax/License",system_defined:"FALSE",active:"TRUE")

    end
end