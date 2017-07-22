namespace :populate_sys_param100 do
	desc "number of days to work on transferred case"
	task :program_unit_transfer => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.create(system_param_categories_id:18,key:"6766",value:"7",description:"Task - To work on transferred program unit - Days to complete = 7.",created_by: 1,updated_by: 1)
	end
end