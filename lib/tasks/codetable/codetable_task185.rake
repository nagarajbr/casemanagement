namespace :populate_codetable185 do
	desc "Add Event List11 "
	task :add_event11 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Complete Eligibility Worker Assignment",long_description:"Complete Eligibility Worker Assignment",system_defined:"TRUE",active:"TRUE")

	end
end