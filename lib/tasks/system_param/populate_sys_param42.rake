namespace :populate_sys_param42 do
	desc "Mapping of Work Type to Number of days to complete the task - Eligibility Warning Follow up"
	task :work_type_task_days_to_complete_pgu_warning_follow_up_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"2138",value:"7",description:"Task -Eligibility Warning Follow up- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end