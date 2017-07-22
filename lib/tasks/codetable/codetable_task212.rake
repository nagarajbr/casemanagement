namespace :populate_codetable212 do
	desc "adding program unit closure entry to action list"
	task :adding_action_list => :environment do
		CodetableItem.create(code_table_id:192,short_description:"Program Unit closure",long_description:"Closure with bonus if good cause",system_defined:"TRUE",active:"TRUE")
	end
end