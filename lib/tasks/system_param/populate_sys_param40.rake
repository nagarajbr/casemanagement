namespace :populate_sys_param40 do
	desc "Additional Mapping of Role to work task types"
	task :role_to_work_task_type_mapping2 => :environment do
# System support Role
		SystemParam.create(system_param_categories_id:24,key:"5",value:"6344",description:"Supervisor Role(5) can see work task type Assign Case Manager to Program Unit (6344)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:24,key:"5",value:"6353",description:"Supervisor Role(5) can see work task type Approve Provider Agreement(6353)",created_by: 1,updated_by: 1)


		SystemParam.create(system_param_categories_id:24,key:"6",value:"6344",description:"Manager Role(6) can see work task type Assign Case Manager to Program Unit (6344)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:24,key:"6",value:"6353",description:"Manager Role(6) can see work task type Approve Provider Agreement(6353)",created_by: 1,updated_by: 1)


		SystemParam.create(system_param_categories_id:24,key:"8",value:"6344",description:"Workload Manager Role(8) can see work task type Assign Case Manager to Program Unit (6344)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:24,key:"8",value:"6353",description:"Workload Manager Role(8) can see work task type Approve Provider Agreement(6353)",created_by: 1,updated_by: 1)

	end
end