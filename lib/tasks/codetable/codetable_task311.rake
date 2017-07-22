namespace :populate_codetable311 do
	desc "ADD new household member status"
	task :add_household_member_status  => :environment do

		CodetableItem.create(code_table_id:201,short_description:"Absent Parent",long_description:"Absent Parent",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:201,short_description:"Authorized Representative",long_description:"Authorized Representative",system_defined:"FALSE",active:"TRUE")

	end
end