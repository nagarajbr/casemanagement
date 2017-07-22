namespace :populate_sys_param55 do
	desc "Mapping of Work Type to Number of days to complete the task - Service Payment tasks"
	task :work_type_task_days_to_work_on_service_payments_tasks => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6469",value:"1",description:"Task - To work on approval of Service Payment - Days to complete = 1",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:18,key:"6470",value:"7",description:"Task - To work on rejected Service Payment - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end
