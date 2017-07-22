namespace :populate_sys_param76 do
	desc "work task time limit"
	task :work_task_time_limit => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		 SystemParam.create(system_param_categories_id:18,key:"6718",value:"7",description:"Task - Prescreening process is complete for the client work on intake process - Days to complete = 7",created_by: 1,updated_by: 1)
	end
end