namespace :populate_codetable151 do
	desc "Requested status added"
	task :request_status_added => :environment do

		CodetableItem.create(code_table_id:160,short_description:"Requested",long_description:"Requested",system_defined:"FALSE",active:"TRUE")
		CodetableItem.where("code_table_id = 160 and id = 6167").update_all("short_description = 'Rejected',long_description = 'Rejected'")
	end
end