namespace :populate_sys_param50 do
	desc "Mapping of Work Type to Number of days to complete the task - work on benefit amount rejected PGU"
	task :work_type_task_days_to_complete_work_on_rejected_pgu=> :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6388",value:"7",description:"Task - work on benefit amount rejected PGU- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end
