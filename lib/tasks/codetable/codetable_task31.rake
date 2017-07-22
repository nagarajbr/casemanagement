namespace :populate_codetable31 do
	desc "delete_ssn_enumeration_codetable_items"
	task :delete_ssn_enumeration_codetable_items => :environment do
		CodetableItem.where("id = 4342 and code_table_id = 74").destroy_all
		CodetableItem.where("id = 5929 and code_table_id = 74").destroy_all
		CodetableItem.where("id = 5928 and code_table_id = 74").destroy_all
		CodetableItem.where("id = 4344 and code_table_id = 74").destroy_all
		CodetableItem.where("id = 4355 and code_table_id = 74").destroy_all
		CodetableItem.where(id: 4343).update_all(short_description:"Verified DWS")


		# Manoj 10/20/2014
		# code table 141 is not needed.
		CodetableItem.where("code_table_id = 141").destroy_all
		# remove code table entry also
		CodeTable.where("id = 141").destroy_all

	end
end