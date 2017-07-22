namespace :populate_sys_param92 do
desc "More work task manual and system closed tasks "
task :Work_task_system_created1 => :environment do
		user_object = User.find(1)
     AuditModule.set_current_user=(user_object)
	SystemParam.create(system_param_categories_id: 9,key:"SYSTEM_CREATED_MANUAL_CLOSE",value:"2151",description:"Deferral/Exemption Follow",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"SYSTEM_CREATED_MANUAL_CLOSE",value:"2138",description:"Eligibility Warning Follow up",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"SYSTEM_CREATED_MANUAL_CLOSE",value:"2152",description:"Death Match",created_by: 1,updated_by: 1)
	#created by system closed by system
	SystemParam.create(system_param_categories_id: 9,key:"SYSTEM_CREATED_SYSTEM_CLOSE",value:"6622",description:"Approve service payment amount above threshold",created_by: 1,updated_by: 1)
	end
end
