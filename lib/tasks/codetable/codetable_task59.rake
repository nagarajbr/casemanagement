namespace :populate_codetable59 do
	desc "update_task_after_task_58"
	task :update_task_after_task_58 => :environment do
		# Inactivate Unknown relationship - so that it will be not available for selection
		CodetableItem.where(id: 6008).update_all(active:"f")
		CodetableItem.where(id: 6094).destroy_all
		# deleted reinstate reasons from close reasons
		CodetableItem.where(id: 4269).destroy_all
		CodetableItem.where(id: 4270).destroy_all
		CodetableItem.where(id: 4271).destroy_all
		CodetableItem.where(id: 4272).destroy_all
		CodetableItem.where(id: 4311).destroy_all
		CodetableItem.where(id: 4312).destroy_all



	end
end