namespace :populate_codetable182 do
	desc "Add Event List8 "
	task :add_event8 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Eligible for planning",long_description:"Eligible for planning - this event will close ED task and create task to assign case manager",system_defined:"TRUE",active:"TRUE")

	end
end