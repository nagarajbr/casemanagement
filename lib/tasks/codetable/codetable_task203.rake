namespace :populate_codetable203 do
	desc "adding date of birth change ed reason"
	task :adding_date_of_birth_change_ed_reasons => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Date of Birth Information Changed",long_description:"Date of Birth Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end