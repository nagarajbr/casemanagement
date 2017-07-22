namespace :populate_codetable170 do
	desc "Add Action2 "
	task :add_action2 => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Complete Task",long_description:"Complete Task",system_defined:"TRUE",active:"TRUE")
	end
end