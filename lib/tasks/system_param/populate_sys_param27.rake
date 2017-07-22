namespace :populate_sys_param27 do
	desc "Mapping of Work Type to Number of days to complete the task"
	task :work_type_task_days_to_complete => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Mapping of Work Type to Number of days to complete the task",created_by: 1,updated_by: 1)
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6344",value:"0",description:"Assign Case Manager to Program Unit -Days to complete = 0",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6346",value:"1",description:"Complete and Activate New Program Unit - Days to complete = 1",created_by: 1,updated_by: 1)
	end
end