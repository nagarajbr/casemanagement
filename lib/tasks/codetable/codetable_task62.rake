namespace :populate_codetable62 do
	desc "cleanup task -payment types"
	task :delete_update_payment_types => :environment do

		CodetableItem.where("id = 5935 and code_table_id = 116").destroy_all
		CodetableItem.where("id = 5760 and code_table_id = 116").update_all(short_description:"Regular")
	end
end