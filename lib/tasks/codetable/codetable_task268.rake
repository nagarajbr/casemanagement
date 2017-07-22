namespace :populate_codetable268 do
	desc "error messages changed for employment "
	task :error_messages_changed_for_employment => :environment do

        CodetableItem.where("id = 6570").update_all(short_description:"Employment requirement",long_description: "No current or future employment")
        CodetableItem.where("id = 6335").update_all(short_description:"Employment rule failed",long_description: "No income due to earnings with minimum 24 hours a week.")
	end
end