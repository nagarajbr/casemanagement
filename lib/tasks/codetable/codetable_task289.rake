namespace :populate_codetable289 do
	desc "Test Description update"
	task :test_description_update => :environment do
		CodetableItem.where("code_table_id = 59 and id = 3104").update_all(active: false)
	end
end