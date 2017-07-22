namespace :populate_sys_param47 do
	desc "Mapping of Work Type to Number of days to complete the task - service payment/invoice rejection"
	task :work_type_task_days_to_complete_rejection_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6384",value:"2",description:"Task -Service payment line item rejection- Days to complete = 2",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:18,key:"6385",value:"2",description:"Task -Provider invoice rejection- Days to complete = 2",created_by: 1,updated_by: 1)
	end
end






