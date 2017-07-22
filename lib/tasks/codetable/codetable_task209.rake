namespace :populate_codetable209 do
	desc "client citizenship status- Verification Pending, SSA Verified and SSA not Verified are made inactive  "
	task :cilent_citizenship_status_inactive => :environment do
		CodetableItem.where("id in (4657,4658,4660)").update_all(active:"FALSE")

	end
end