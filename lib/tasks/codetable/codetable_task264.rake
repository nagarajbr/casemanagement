namespace :populate_codetable264 do
	desc "add household member entity"
	task :household_member_entity => :environment do
		CodetableItem.create(code_table_id:145,short_description:"Household Member",long_description:"Household Member",system_defined:"FALSE",active:"TRUE")
	end
end