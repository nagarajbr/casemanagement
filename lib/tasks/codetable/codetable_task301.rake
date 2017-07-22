namespace :populate_codetable301 do
	desc "Make few test types inactive"
	task :update_test_type_to_inactive => :environment do

		CodetableItem.where("code_table_id = 59 and id = 3109").update_all(active:"FALSE")
		CodetableItem.where("code_table_id = 59 and id = 3110").update_all(active:"FALSE")
		CodetableItem.where("code_table_id = 59 and id = 3103").update_all(active:"FALSE")

	end
end