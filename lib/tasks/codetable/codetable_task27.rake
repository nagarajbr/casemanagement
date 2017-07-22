namespace :populate_codetable27 do
	desc "Application Disposition Status list"
	task :application_disposition_status_cleanup => :environment do

		# registered status is deleted
		CodetableItem.where("code_table_id = 127 and id = 6019 ").destroy_all
		# approved status changed to "Accepted" from Approoved
		CodetableItem.where(id: 6017).update_all(short_description: "Accepted")
		# approved status changed to "Rejected" from Denied
		CodetableItem.where(id: 6018).update_all(short_description: "Rejected")

	end
end