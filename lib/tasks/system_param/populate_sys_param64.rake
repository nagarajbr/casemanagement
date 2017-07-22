namespace :populate_sys_param64 do
	desc "Mapping of Work Type to Number of days to complete the task - Work on Employment Planning and CPP"
	task :work_type_task_days_to_complete_rejection_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6605",value:"2",description:"Task -Work on Employment Planning and CPP- Days to complete = 2",created_by: 1,updated_by: 1)

	end
end