namespace :populate_codetable193 do
	desc "notes types"
	task :update_notes_type => :environment do
		CodetableItem.where("id = 6521").update_all(long_description:"ProviderService")
		CodetableItem.where("id = 6522").update_all(long_description:"Employers")
		CodetableItem.where("id = 6523").update_all(long_description:"School")
	end
end