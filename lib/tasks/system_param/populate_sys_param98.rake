namespace :populate_sys_param98 do
	desc "Mapping of Work Type to Number of days to complete the task - Assessment changed by other user"
	task :populate_sys_param98 => :environment do
		# Worktype to days key value pairs
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.create(system_param_categories_id:18,key:"6764",value:"2",description:"Task -Assessment changed by other user- Days to complete = 2")
	end
end