namespace :populate_codetable_task295 do
	desc "Work Order Types"
	task :work_order_types_updated => :environment do
		CodetableItem.where(id: 6387).update_all(short_description:"Complete Work Readiness Assessment", long_description:"Complete Work Readiness Assessment")
	end
end
