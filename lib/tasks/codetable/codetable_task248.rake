namespace :populate_codetable248 do
	desc "Provider Queues"
	task :adding_provider_queues => :environment do
		CodetableItem.where("id=6565").update_all(short_description:"Approved Provider Service Payments Queue",long_description:"Approved Provider Service Payments Queue")
		CodetableItem.create(code_table_id:196,short_description:"Approved Provider Agreement Queue",long_description:"Approved Provider Agreement Queue",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:196,short_description:"Ready for AASIS Verification Queue",long_description:"Ready for AASIS Verification Queue",system_defined:"TRUE",active:"TRUE")
		CodetableItem.create(code_table_id:196,short_description:"AASIS Verified Providers Queue",long_description:"AASIS Verified Providers Queue",system_defined:"TRUE",active:"TRUE")
	end
end