namespace :populate_codetable272 do
	desc "approve provider payment queue"
	task :add_approve_provider_payment_queue => :environment do
		CodetableItem.create(code_table_id:196,short_description:"Approve provider payment queue",long_description:"Approve provider payment queue",system_defined:"FALSE",active:"TRUE")
	end
end