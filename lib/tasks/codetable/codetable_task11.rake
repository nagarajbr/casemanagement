namespace :codetable_task11 do
	desc "Cleaning up Ethnicity values"
	task :Ethnicity_update => :environment do
		CodetableItem.where(id: 438).update_all(short_description:"American Indian/Alaska Native", long_description:"American Indian/Alaska Native")
		CodetableItem.where(id: 439).update_all(short_description:"Asian", long_description:"Asian")
		CodetableItem.where(id: 440).update_all(short_description:"African American/Black",long_description:"African American/Black")
		CodetableItem.where(id: 441).update_all(short_description:"Caucasian/White",long_description:"Caucasian/White")
		CodetableItem.where(id: 442).update_all(short_description:"Pacific Islander/Hawaii Native",long_description:"Pacific Islander/Native Hawaiian")
		CodetableItem.where(id: 443).update_all(short_description:"Other",long_description:"Other")
		CodetableItem.where("code_table_id = 9 and id > 443 ").destroy_all
	end
end