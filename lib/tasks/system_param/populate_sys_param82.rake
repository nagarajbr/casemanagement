namespace :populate_sys_param82 do
	desc "Mapping of Work Type to Number of days to complete the task - complete application intake"
	task :populate_sys_param82 => :environment do
		# Worktype to days key value pairs
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.create(system_param_categories_id:18,key:"6736",value:"2",description:"Task -complete application intake- Days to complete = 2",created_by: 1,updated_by: 1)
	end
end