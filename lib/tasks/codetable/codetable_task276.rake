namespace :populate_codetable276 do
	desc "Prescreening queue"
	task :prescreening_queue => :environment do
		CodetableItem.create(code_table_id:196,short_description:"Prescreening queue",long_description:"Prescreening queue",system_defined:"TRUE",active:"TRUE",sort_order: 5)
	end
end