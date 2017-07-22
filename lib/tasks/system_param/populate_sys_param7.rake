namespace :populate_sys_param7 do
	desc "Pagination"
	task :pagination => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Pagination",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"records",value:"10",description:"Records Per Page",created_by: 1,updated_by: 1)
	end

end