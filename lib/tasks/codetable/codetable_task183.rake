namespace :populate_codetable183 do
	desc "Add Event List9 "
	task :add_event9 => :environment do
		CodetableItem.create(code_table_id:191,short_description:"Continue Assessment",long_description:"Continue Assessment - this event will close ED task and create task to work on the Case.",system_defined:"TRUE",active:"TRUE")
	end
end