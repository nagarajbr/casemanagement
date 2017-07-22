namespace :populate_sys_param104 do
	desc "work task system created and system closed tasks "
	task :Work_task_system_created_system_close => :environment do
	#created by system closed manually
	user_object = User.find(1)
    AuditModule.set_current_user=(user_object)
    SystemParam.create(system_param_categories_id: 9,key:"SYSTEM_CREATED_SYSTEM_CLOSE",value:"2155",description:"Identify Program Units",created_by: 1,updated_by: 1)
	end
end
