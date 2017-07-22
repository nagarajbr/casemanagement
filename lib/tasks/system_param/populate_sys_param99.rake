namespace :populate_sys_param99 do
	desc "Barrier Mapped to Activity Type"
	task :barrier_mapping_to_activity_type => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.create(system_param_categories_id:20,key:"3",value:"6279",description:"",created_by: 1,updated_by: 1)
	end
end