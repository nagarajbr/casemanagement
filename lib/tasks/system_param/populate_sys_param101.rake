namespace :populate_sys_param101 do
	desc "Action Mapped to Federal Components"
	task :action_mapping_to_federal_component => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		SystemParam.create(system_param_categories_id:16,key:"6770",value:"6771",description:"Job Readiness Mapped To Job Readiness(Core)",created_by: 1,updated_by: 1)
	end
end