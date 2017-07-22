namespace :populate_codetable259 do
	desc "Provider queue"
	task :provider_queue_names => :environment do
		code_table_object = CodeTable.create(name:"Provider Queues",description:"Provider Queues")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Ready for FMS review",long_description:"Ready for FMS review",system_defined:"FALSE",active:"TRUE")
		CodetableItem.create(code_table_id:code_table_object.id,short_description:"Ready for provider agreements approval",long_description:"Ready for provider agreements approval",system_defined:"FALSE",active:"TRUE")
	end
end