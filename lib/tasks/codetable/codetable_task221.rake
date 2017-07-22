namespace :populate_codetable221 do
	desc "adding relationship information changed ed reason"
	task :adding_action_type_create_queue => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Create Queue",long_description:"Create records in Queue",system_defined:"TRUE",active:"TRUE")
	end
end