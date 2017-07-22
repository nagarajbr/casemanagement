namespace :populate_codetable225 do
	desc "adding action type AASIS verification"
	task :adding_action_type_aasis_verification => :environment do
		CodetableItem.create(code_table_id:192,short_description:"AASIS verification",long_description:"AASIS verification",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:193,short_description:"AASIS verification",long_description:"AASIS verification",system_defined:"FALSE",active:"TRUE")
	end
end