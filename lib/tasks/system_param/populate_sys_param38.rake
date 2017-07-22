namespace :populate_sys_param38 do
	desc "Mapping of Work Type - work on sanction task to Number of days to complete the task"
	task :work_type_task_days_to_complete3 => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6367",value:"15",description:"Work on Sanction Task- Days to complete = 15",created_by: 1,updated_by: 1)
	end
end