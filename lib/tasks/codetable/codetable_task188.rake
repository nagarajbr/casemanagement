namespace :populate_codetable188 do
	desc "Adding benficiary types "
	task :add_beneficiary_types  => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Income Detail",long_description:"Income Detail",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Resource Detail",long_description:"Resource Detail",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:162,short_description:"Client",long_description:"Client",system_defined:"FALSE",active:"TRUE")
	end
end

