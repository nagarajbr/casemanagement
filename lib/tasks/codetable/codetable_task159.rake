namespace :populate_codetable159 do
	desc "Case transfer work task type  "
	task :case_transfer_work_task_type => :environment do

		CodetableItem.where("code_table_id = 18 and id = 2176").update_all("short_description = 'Case Transfer',long_description = 'Case Transfer'")
	end
end