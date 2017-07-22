namespace :populate_codetable147 do
	desc "work_task_type - Eligibility Warning Follow up"
	task :work_task_type_ed_warning_follow_up => :environment do
		# Modify Apply online - Budget transaction task type to Eligibility Warning Follow Up
		CodetableItem.where("id = 2138").update_all("short_description = 'Eligibility Warning Follow up',long_description = 'Eligibility Warning Follow up'")

	end
end