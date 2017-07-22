namespace :populate_sys_param46 do
	desc "Mapping of Work Type to Number of days to complete the task - assign different user"
	task :work_type_task_days_to_complete_task_2176 => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"2176",value:"7",description:"Task -assign different user- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end




