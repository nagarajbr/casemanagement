namespace :populate_sys_param102 do
	desc "Action Mapped to Federal Components"
	task :action_mapping_to_barrier_and_federal_component => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
    	# Service activity type "Add Participate in GED certification" mapped to barrier 'No high school diploma'
		SystemParam.create(system_param_categories_id:22,key:"7",value:"6772",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6772",value:"6240",description:"Participate in GED certification Mapped To Career and Technical Education(Core)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6772",value:"6268",description:"Participate in GED certification Mapped To Education Directly Related to Employment(Non Core)",created_by: 1,updated_by: 1)
	end
end