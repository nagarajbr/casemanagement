namespace :populate_codetable153 do
	desc "Approve Program Unit Work Task "
	task :work_task_approve_Program_unit => :environment do

		CodetableItem.where("code_table_id = 18 and id = 2172").update_all("short_description = 'Approve Program Unit',long_description = 'Approve Program Unit'")
	end
end