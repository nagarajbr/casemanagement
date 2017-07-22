namespace :populate_codetable237 do
	desc "citizenship not verified updated"
	task :citizenship_not_verified => :environment do
		CodetableItem.where(id: 5878).update_all(short_description:"Citizenship not verified", long_description:"Citizenship not verified")
	end
end