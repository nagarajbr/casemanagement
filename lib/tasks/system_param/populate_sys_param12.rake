namespace :populate_sys_param12 do
	desc "Time Limits Count"
	task :time_limits_count => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Time Limits",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"STATE_TIME_LIMITS",value:"24",description:"State Time Limits Count.",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"FEDERAL_TIME_LIMITS",value:"60",description:"Federal Time Limits Count.",created_by: 1,updated_by: 1)
	end
end