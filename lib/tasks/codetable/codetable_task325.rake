namespace :populate_codetable325 do
	desc "out of household reason"
	task :out_of_household_reason  => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Client is made Inactive closed since he moved out of household",long_description:"Client is made Inactive closed since he moved out of household",system_defined:"FALSE",active:"TRUE")
	end
end