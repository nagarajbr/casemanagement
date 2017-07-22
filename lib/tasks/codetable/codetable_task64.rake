namespace :populate_codetable64 do
	desc "Update items to action indicator"
	task :update_action_indicator_items => :environment do
		CodetableItem.where("id = 6056 and code_table_id = 135").update_all(short_description:"L",long_description:"L")
	end
end