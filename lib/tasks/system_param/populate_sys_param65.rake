namespace :populate_sys_param65 do
	desc "Mapping of Work Type to Number of days to complete the task - Approve CPP"
	task :work_type_task_days_to_approve_cpp => :environment do
		SystemParam.create(system_param_categories_id:18,key:"6607",value:"3",description:"Task - To approve CPP - Days to complete = 3",created_by: 1,updated_by: 1)
	end
end
