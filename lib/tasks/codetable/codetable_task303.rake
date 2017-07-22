namespace :populate_codetable303 do
	desc "household entity type for notes"
	task :household_notes => :environment do

		CodetableItem.create(code_table_id: 155,short_description:"Household",long_description:"Household",system_defined:"FALSE",active:"TRUE")

	end
end