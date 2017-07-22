namespace :populate_codetable157 do
	desc "additional work task types"
	task :additional_work_task_types => :environment do

		CodetableItem.where("code_table_id = 18 and id = 2143").update_all("short_description = 'Service payment line items Approval',long_description = 'Service payment line items Approval'")
		CodetableItem.where("code_table_id = 18 and id = 2144").update_all("short_description = 'Provider Invoice Authorization',long_description = 'Provider Invoice Authorization'")


	end
end