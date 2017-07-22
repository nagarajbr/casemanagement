namespace :populate_sys_param79 do
	desc "work task - activity Follow Up"
	task :work_task_for_activity => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		 SystemParam.create(system_param_categories_id:18,key:"2140",value:"7",description:"Task - To work on activity- Days to complete = 7",created_by: 1,updated_by: 1)
	end
end