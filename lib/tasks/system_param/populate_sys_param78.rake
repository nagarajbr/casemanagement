namespace :populate_sys_param78 do
	desc "Update Employment Service Barrier Mapped to Activity Type"
	task :update_mapping_barrier_to_newly_added_service_type => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.where(system_param_categories_id:22,key:"6",value:"6722").update_all(key:"2")
		SystemParam.create(system_param_categories_id:22,key:"3",value:"6722",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:22,key:"6",value:"6722",created_by: 1,updated_by: 1)
	end
end