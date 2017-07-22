namespace :populate_codetable184 do
	desc "Add Event List10 "
	task :add_event10 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Complete Case Manager Assignment",long_description:"Complete Case Manager Assignment",system_defined:"TRUE",active:"TRUE")

	end
end