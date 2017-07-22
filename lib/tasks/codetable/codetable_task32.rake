namespace :codetable_task32 do
	desc "phone_type_change"
	task :phone_type_change => :environment do
		CodetableItem.where(id: 4661).update_all(short_description:"Primary", long_description:"Primary")
		CodetableItem.where(id: 4662).update_all(short_description:"Secondary", long_description:"Secondary")
		CodetableItem.where(id: 4663).update_all(short_description:"Other", long_description:"Other")

	end
end