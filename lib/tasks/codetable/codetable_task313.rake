namespace :populate_codetable313 do
	desc "Update prescreen queue to inactive"
	task :Update_prescreen_queue_to_inactive => :environment do
         # "Prescreening queue"
        CodetableItem.where("id = 6717 and code_table_id = 196").update_all(active:false)
	end
end