namespace :populate_codetable33 do
	desc "delete_citizenship_verification_type"
	task :delete_citizenship_verification_type => :environment do
		#CodetableItem.where("id = 4659 and code_table_id = 101").destroy_all
		CodetableItem.where(id: 4655).update_all(short_description:"Verified DWS")
		# Delete Absent Parent relationship from budget relationship as it will be handled in Parental relationship (123)
		CodetableItem.where("id = 5944 and code_table_id = 125").destroy_all

	end
end