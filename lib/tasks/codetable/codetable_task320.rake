namespace :populate_codetable320 do
	desc "Remove Deemer from employment details status"
	task :remove_deemer_employment_detail_status => :environment do
		CodetableItem.where("code_table_id = 28 and id = 5885 ").destroy_all
	end
end