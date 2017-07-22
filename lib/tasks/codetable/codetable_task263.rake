namespace :populate_codetable263 do
	desc "household member status"
	task :household_member_status => :environment do
		code_table_object = CodeTable.create(name:"Household Member Status",description:"Household Member Status")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"In Household",long_description:"In Household",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Out of Household",long_description:"Out of Household",system_defined:"FALSE",active:"TRUE")
	end
end