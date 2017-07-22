namespace :populate_codetable257 do
	desc "Adding reason to run ed "
	task :adding_ed_reason_for_turning_18  => :environment do
		#194-"Eligibility Determination Reasons"
		codetableitems = CodetableItem.create(code_table_id:194,short_description:"Child Turned 18",long_description:"Child Turned 18",system_defined:"FALSE",active:"TRUE")


	end
end