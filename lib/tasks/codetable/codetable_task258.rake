namespace :populate_codetable258 do
	desc "Delete codetable items"
	task :delete_code_table_items => :environment do
		CodetableItem.where("id = 6566 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6565 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6564 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6563 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6561 and code_table_id = 196").destroy_all

		CodetableItem.where("id = 6628 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6629 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6631 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6627 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6632 and code_table_id = 196").destroy_all

		CodetableItem.where("id = 6626 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6580 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6568 and code_table_id = 196").destroy_all
		CodetableItem.where("id = 6625 and code_table_id = 196").destroy_all
	end
end