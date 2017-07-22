namespace :populate_codetable245 do
	desc "Ownership Types"
	task :adding_ownership_type => :environment do
		CodetableItem.create(code_table_id:199,short_description:"Employment Planning",long_description:"Employment Planning",system_defined:"TRUE",active:"TRUE")
	end
end