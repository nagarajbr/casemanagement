namespace :populate_sys_param52 do
	desc "Events to Actions Mapping"
	task :events_to_actions_mapping => :environment do
		systemParamCategory_object = SystemParamCategory.create(description:"Events to Actions Mapping",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategory_object.id,key:"6444",value:"6445",description:"Event : Transfer of Case to new local office, Action: create_task",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategory_object.id,key:"6444",value:"6446",description:"Event : Transfer of Case to new local office, Action: create_alert",created_by: 1,updated_by: 1)
	end
end



