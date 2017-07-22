namespace :populate_codetable288 do
	desc "Work Order Type update "
	task :Work_Order_Types_update  => :environment do
		CodetableItem.where("code_table_id = 18 and id = 2145").update_all(short_description: "Income Mismatch",long_description:"Income Mismatch")

	end
end