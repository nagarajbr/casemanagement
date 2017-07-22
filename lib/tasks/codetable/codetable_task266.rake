namespace :populate_codetable266 do
	desc "add a new Ownership Types"
	task :reevaluation_ownership_types => :environment do
		CodetableItem.create(code_table_id: 199,short_description:"Re-evaluation",long_description:"Re-evaluation",system_defined:"TRUE",active:"TRUE")
	end
end