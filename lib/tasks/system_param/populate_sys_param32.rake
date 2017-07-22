namespace :populate_sys_param32 do
	desc "Mapping of Work Type to Number of days to complete the task2"
	task :work_type_task_days_to_complete2 => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6353",value:"7",description:"Approve Provider Agreement- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end