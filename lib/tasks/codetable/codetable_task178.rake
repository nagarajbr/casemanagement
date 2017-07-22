namespace :codetable_task178 do
	desc "update_task_beneficiary_type"
	task :update_task_beneficiary_type => :environment do
		CodetableItem.where(id: 6382).update_all(short_description:"Service Authorization Line Item", long_description:"Service Authorization Line Item")
	end
end