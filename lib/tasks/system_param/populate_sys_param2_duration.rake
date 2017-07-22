namespace :populate_sys_param2 do
	desc "Date Durations"
	task :durations => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Duration Type",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WEEK",value:"7",description:"1 Week",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"DAY",value:"30",description:"30 Days",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"MONTH",value:"1",description:"1 Month",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"DAY",value:"60",description:"60 days",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"MONTH",value:"3",description:"3 Months",created_by:1,updated_by:1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"DAY",value:"90",description:"90 days",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"MONTH",value:"6",description:"6 Months",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"DAY",value:"180",description:"180 days",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"MONTH",value:"9",description:"9 Months",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"MONTH",value:"24",description:"24 Months",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"YEAR",value:"1",description:"1 year",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"LIFETIME",value:"100",description:"Lifetime",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"UNDETERMINED",value:"100",description:"Undetermined",created_by: 1,updated_by: 1)

	end

end