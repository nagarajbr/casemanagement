namespace :populate_sys_param14 do
	desc "ATTOP release versions"
	task :attop_release_versions => :environment do
		systemParamCategories = SystemParamCategory.create(description:"ATTOP release versions",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"RELEASE_NAME",value:"Petit Jean Beta",description:"Release name",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"RELEASE_REGION",value:"UAT",description:"Release region name",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"VERSION_NUMBER",value:"1.0",description:"Version number",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"RELEASE_DATE",value:"2014-11-24",description:"Release date",created_by: 1,updated_by: 1)
	end
end