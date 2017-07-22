namespace :populate_sys_param97 do
	desc "barrier related mapping to High school diploma is updated and Currently not working -  "
	task :Action_and_service_mapping => :environment do

		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

    	SystemParam.where("id in (1122,1168,1169)").destroy_all
    	SystemParam.where("id = 1012 and system_param_categories_id = 16 and key = '6317'").update_all(value:'6240')

	end
end
