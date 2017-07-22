namespace :populate_sys_param48 do
	desc "Mapping of Work Type to Number of days to complete the task - assign ED worker"
	task :work_type_task_days_to_complete_assign_ed_worker_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6386",value:"1",description:"Task - Assign Eligibility Worker to Program Unit- Days to complete = 1",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:18,key:"6387",value:"7",description:"Task -Complete Work Readiness Assessment and CPP- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end

