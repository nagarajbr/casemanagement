namespace :populate_codetable309 do
	desc "Update short and long description for notes and work charactertics"
	task :Update_short_and_long_description => :environment do
         #address changed to contact in notes
        CodetableItem.where("id = 6474").update_all(short_description:"Contact",long_description: "Contact")
        #Mandatory changed to Required to work in work charactertics
        CodetableItem.where("id = 5667").update_all(short_description:"Required to work",long_description: "Required to work")
	end
end