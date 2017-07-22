namespace :populate_codetable125 do
	desc "school entity added"
	task :school_entity => :environment do
		codetableitems = CodetableItem.create(code_table_id:155,short_description:"School",long_description:"School",system_defined:"FALSE",active:"TRUE")
	end
end