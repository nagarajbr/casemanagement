namespace :populate_sys_param45 do
	desc "Additional Mapping of Work Type to Number of days to complete the task"
	task :additional_work_type_task_days_to_complete_approve_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"2143",value:"7",description:"Task -Service payment line items Approval- Days to complete = 7",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:18,key:"2144",value:"7",description:"Provider Invoice Authorization- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end