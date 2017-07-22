namespace :populate_sys_param49 do
	desc "Mapping of Work Type to Number of days to complete the task - case transfer"
	task :work_type_task_days_to_complete_case_transfer=> :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"2178",value:"7",description:"Task -case transfer- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end
