namespace :populate_sys_param6 do
	desc "Age"
	task :age => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Age",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"child_age",value:"19",description:"Child Age",created_by: 1,updated_by: 1)
	end
end