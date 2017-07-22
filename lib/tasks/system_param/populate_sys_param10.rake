namespace :populate_sys_param10 do
	desc "General Application Parameters"
	task :general_application_parameters => :environment do
		systemParamCategories = SystemParamCategory.create(description:"General Application Parameters",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"REINSTATE_DAYS_LIMIT",value:"30",description:"Reinstate is allowed after 30 days of Close action date.",created_by: 1,updated_by: 1)
	end

end