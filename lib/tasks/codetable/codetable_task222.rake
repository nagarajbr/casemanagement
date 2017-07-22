namespace :populate_codetable222 do
	desc "adding client application as reference type"
	task :populate_codetable222 => :environment do
		CodetableItem.create(code_table_id:162,short_description:"Client Application",long_description:"Client Application",system_defined:"TRUE",active:"TRUE")
	end
end