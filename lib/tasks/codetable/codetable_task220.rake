namespace :populate_codetable220 do
	desc "adding relationship information changed ed reason"
	task :adding_relationship_information_changed_ed_reason => :environment do
		CodetableItem.create(code_table_id:194,short_description:"Relationship Information Changed",long_description:"Relationship Information Changed",system_defined:"TRUE",active:"TRUE")
	end
end