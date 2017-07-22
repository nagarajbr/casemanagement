namespace :populate_codetable194 do
	desc "data required for ED task type when there is change in address infor"
	task :event_to_action_mapping_date_for_address_change => :environment do
		CodetableItem.create(code_table_id:155,short_description:"Program Unit",long_description:"Program Unit",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:192,short_description:"Eligibility Determination",long_description:"Redetermine ED",system_defined:"FALSE",active:"TRUE") #Action Type
		CodetableItem.create(code_table_id:193,short_description:"Eligibility Determination",long_description:"Eligibility Determination",system_defined:"FALSE",active:"TRUE") # Process Type
	end
end