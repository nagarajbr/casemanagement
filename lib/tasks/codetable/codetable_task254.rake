namespace :populate_codetable254 do
	desc "Adding reason to run ed "
	task :adding_ed_reasons  => :environment do
		#194-"Eligibility Determination Reasons"
		codetableitems = CodetableItem.create(code_table_id:194,short_description:"Ineligible due to SSI",long_description:"Ineligible due to SSI",system_defined:"FALSE",active:"TRUE")


	end
end