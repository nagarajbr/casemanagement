namespace :populate_codetable150 do
	desc "Work type addition "
	task :update_work_type_ed_information_changed => :environment do
		CodetableItem.where("code_table_id = 18 and id = 2142").update_all("short_description = 'ED Data Changed',long_description = 'Income/Resource/citizenship/residency/address data changed -Run ED to verify eligibility'")
		CodetableItem.where("code_table_id = 18 and id = 2173").update_all("short_description = 'Client Information Changed',long_description = 'Client Information Changed'")
    end
end