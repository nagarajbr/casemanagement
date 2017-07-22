namespace :populate_codetable241 do
	desc "codetable items for queue"
	task :creating_reval_and_open_PU_queue_codetableitems => :environment do
		CodetableItem.create(code_table_id: 196 ,short_description:"Reevaluation Queue",long_description:"Reevaluation Queue",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id: 196 ,short_description:"Open program unit Queue",long_description:"Open program unit Queue",system_defined:"TRUE",active:"TRUE")
	end
end