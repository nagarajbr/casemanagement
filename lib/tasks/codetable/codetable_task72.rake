namespace :populate_codetable72 do
	desc "ED Validation Items"
	task :ed_validation_item => :environment do
		 CodetableItem.create(code_table_id:130,short_description:"Adult not included in eligibility determination",long_description:"Adult not included in eligibility determination",system_defined:"FALSE",active:"TRUE")
		  CodetableItem.create(code_table_id:130,short_description:"Both Parent and child should be included in eligibility determination",long_description:"Parent not included in eligibility determination",system_defined:"FALSE",active:"TRUE")
	end
end