namespace :populate_sys_param56 do
	desc "Mapping of Work Type to Number of days to complete the task - Provider Invoice tasks"
	task :work_type_task_days_to_work_on_provider_invoice_tasks => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6491",value:"7",description:"Task - To work on approval of Provider Invoice - Days to complete = 7",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:18,key:"6492",value:"7",description:"Task - To work on rejected Provider Invoice - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end
