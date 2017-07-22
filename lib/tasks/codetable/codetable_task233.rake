namespace :populate_codetable233 do
	desc "adding death of death ed reason"
	task :adding_date_of_death_ed_reason => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Client Date of Death Entered",long_description:"Client Date of Death Entered",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:194,short_description:"Employment Detail Information Changed",long_description:"Employment Detail Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end