namespace :populate_codetable240 do
	desc "disposition_reason_ready_for_ed"
	task :disposition_reason_ready_for_ed => :environment do
		
        CodetableItem.where("id = 6045").update_all(short_description:"Ready for eligibility determination")
	end
end