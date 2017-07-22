namespace :populate_sys_param88 do
	desc "More Action/Service Mapped to Federal Components"
	task :action_service_mapping_to_federal_component4 => :environment do
		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		SystemParam.create(system_param_categories_id:16,key:"6319",value:"6358",description:"",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6320",value:"6358",description:"",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6741",value:"6358",description:"",created_by: 1,updated_by: 1)
	end
end