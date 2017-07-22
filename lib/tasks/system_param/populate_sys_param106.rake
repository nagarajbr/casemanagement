namespace :populate_sys_param106 do
	desc "work task category "
	task :Work_task_category => :environment do
	user_object = User.find(1)
    AuditModule.set_current_user=(user_object)

    SystemParam.create(system_param_categories_id: 9,key:"WORK_TASK_CATEGORY",value:"6366",description:"Client",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"WORK_TASK_CATEGORY",value:"6352",description:"Provider",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"WORK_TASK_CATEGORY",value:"6200",description:"Supportive Services",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"WORK_TASK_CATEGORY",value:"6199",description:"TEA Diversion",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"WORK_TASK_CATEGORY",value:"6198",description:"Work pays",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"WORK_TASK_CATEGORY",value:"6197",description:"TEA",created_by: 1,updated_by: 1)

   end
end