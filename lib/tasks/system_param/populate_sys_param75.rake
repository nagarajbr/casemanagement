namespace :populate_sys_param75 do
	desc "work task time limit"
	task :work_task_time_limit => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		 SystemParam.create(system_param_categories_id:18,key:"6716",value:"10",description:"Task - work on Potentially eligible for sanction - Days to complete = 10",created_by: 1,updated_by: 1)
	end
end