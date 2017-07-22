namespace :populate_codetable211 do
	desc "adding notice generation entry to action list"
	task :adding_action_list => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Create Notice Generation Information",long_description:"Create Notice Generation Information",system_defined:"TRUE",active:"TRUE")
	end
end