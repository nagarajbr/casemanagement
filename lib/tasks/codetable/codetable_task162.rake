namespace :populate_codetable162 do
	desc "assign different case manager"
	task :assign_different_user_to_pgu => :environment do

		CodetableItem.where("code_table_id = 18 and id = 2178").update_all("short_description = 'Case Transfer',long_description = 'Case Transfer'")
		CodetableItem.where("code_table_id = 18 and id = 2176").update_all("short_description = 'Assign different user to program unit',long_description = 'Assign different user to program unit'")



	end
end