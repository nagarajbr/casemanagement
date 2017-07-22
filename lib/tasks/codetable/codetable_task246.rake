namespace :populate_codetable246 do
	desc "Ownership Types2"
	task :adding_ownership_type_application => :environment do
		CodetableItem.create(code_table_id:199,short_description:"Application Intake and screening",long_description:"Application Intake and screening",system_defined:"TRUE",active:"TRUE")
	end
end