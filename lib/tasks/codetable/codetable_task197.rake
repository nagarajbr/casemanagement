namespace :populate_codetable197 do
	desc "notes types"
	task :update_notes_type => :environment do
		CodetableItem.where("id = 6527").update_all(long_description: "Case Assessment")
		CodetableItem.where("id = 6528").update_all(long_description: "Interview")
		CodetableItem.where("id = 6529").update_all(long_description: "Other")
	end
end