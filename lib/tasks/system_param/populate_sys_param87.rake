namespace :populate_sys_param87 do
	desc "Barrier Mapped to Activity Type for child care "
	task :barrier_mapping_to_activity_type_for_child_care => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
			SystemParam.create(system_param_categories_id:21,key:"12",value:"6741",description:"Take care of child(ren)",created_by: 1,updated_by: 1)
	end
end