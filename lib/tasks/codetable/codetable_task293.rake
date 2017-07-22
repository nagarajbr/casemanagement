namespace :populate_codetable293 do
	desc "Adding deemed no finance data types"
	task :add_additional_finance_types  => :environment do
		CodetableItem.create(code_table_id:36,short_description:"Deemed no income",long_description:"Deemed no income",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:34,short_description:"Deemed no resource",long_description:"Deemed no resource",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:35,short_description:"Deemed no expense",long_description:"Deemed no expense",system_defined:"FALSE",active:"TRUE")
	end
end