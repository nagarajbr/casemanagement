namespace :populate_codetable292 do
	desc "Adding state type"
	task :add_state_for_submitted_state  => :environment do
		CodetableItem.create(code_table_id:160,short_description:"Submitted",long_description:"Submitted",system_defined:"FALSE",active:"TRUE")
	end
end