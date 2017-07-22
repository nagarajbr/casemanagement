namespace :populate_codetable333 do
	desc "Data Validation Items"
	task :add_data_validation_items => :environment do
		CodetableItem.create(code_table_id:129,short_description:"Learning Difficulty Screening",long_description:"Learning Difficulty Screening",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:129,short_description:"Career Interests",long_description:"Career Interests",system_defined:"FALSE",active:"TRUE")
	end
end