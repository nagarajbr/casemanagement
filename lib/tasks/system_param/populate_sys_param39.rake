namespace :populate_sys_param39 do
	desc "Mapping of Role to work task types"
	task :role_to_work_task_type_mapping => :environment do
		# Tasks which are assigned to LOcal office needs to filtered by Role.
		systemParamCategories = SystemParamCategory.create(description:" Mapping of Roles to work task types",created_by: 1,updated_by: 1)
		# Worktype to days key value pairs

		# System support Role
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"2",value:"6344",description:"System Support Role(1) can see work task type Assign Case Manager to Program Unit (6344)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"2",value:"6353",description:"System Support Role(1) can see work task type Approve Provider Agreement(6353)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"2",value:"2168",description:"System Support Role(1) can see work task type sanctions (2168)",created_by: 1,updated_by: 1)

		# Compliance Role.
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"12",value:"2168",description:"System Support Role(1) can see work task type sanctions (2168)",created_by: 1,updated_by: 1)

	end
end