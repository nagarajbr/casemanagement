namespace :populate_codetable328 do
	desc "adding_activity_type"
	task :adding_actions  => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Delete Pending Work Tasks",long_description:"Delete Pending Work Tasks",system_defined:"TRUE",active:"TRUE")
	end
end