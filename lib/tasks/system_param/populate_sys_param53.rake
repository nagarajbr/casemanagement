namespace :populate_sys_param53 do
	desc "Mapping of Work Type to Number of days to complete the task - To work on rejected CPP"
	task :work_type_task_days_to_work_on_rejected_cpp => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6463",value:"1",description:"Task - Request to approve CPP - Days to complete = 1",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:18,key:"6464",value:"7",description:"Task - To work on rejected CPP - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end
