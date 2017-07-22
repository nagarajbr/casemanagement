namespace :populate_codetable148 do
	desc "Modify service line item status "
	task :update_line_item_status => :environment do
		CodetableItem.where("code_table_id = 161 and id = 6169").update_all("short_description = 'Submitted',long_description = 'Submitted'")
		CodetableItem.where("code_table_id = 161 and id = 6168").update_all("short_description = 'Reported',long_description = 'Reported'")
		CodetableItem.create(code_table_id:161,short_description:"Generated",long_description:"Initial line item status when it is created or generated.",system_defined:"FALSE",active:"TRUE")
    end
end