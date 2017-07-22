namespace :populate_codetable296 do
	desc "Vehicle Insurance,Vehicle Down Payment,Vehicle Down Payment - inactivate    "
	task :provider_service_active_false => :environment do
	   CodetableItem.where("id in (6361,6362,6359)").update_all(active:"FALSE")

	end
end
