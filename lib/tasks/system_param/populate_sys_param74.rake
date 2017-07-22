namespace :populate_sys_param74 do
	desc "reevaluation task time limit"
	task :reval_task_time_limit => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		 SystemParam.create(system_param_categories_id:18,key:"2154",value:"7",description:"Task - To work on reevaluation task - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end