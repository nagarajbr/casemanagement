namespace :populate_codetable111 do
	desc "Add Outcome Entities "
	task :add_outcome_entities  => :environment do
		CodetableItem.create(code_table_id:175,short_description:"Supportive Service",long_description:"Supportive Service",system_defined:"FALSE",active:"TRUE")
	end
end