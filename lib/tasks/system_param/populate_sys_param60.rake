namespace :populate_sys_param60 do
	desc "Mapping of Work Type to Number of days to complete the task - Close activities on Program Unit closure"
	task :work_type_task_days_to_close_pgu_task => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:18,key:"6576",value:"3",description:"Task -Close activities on Program Unit closure = 3",created_by: 1,updated_by: 1)
	end
end