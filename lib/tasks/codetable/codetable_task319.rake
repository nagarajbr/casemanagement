namespace :populate_codetable319 do
	desc "Remove Gang Activities from legal characteristics"
	task :remove_gang_activities_from_legal_characteristics => :environment do
		CodetableItem.where("code_table_id = 206 and id = 5616 ").destroy_all
	end
end