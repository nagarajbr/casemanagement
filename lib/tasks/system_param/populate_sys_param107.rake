namespace :populate_sys_param107 do
	desc "updating key for 'Client Characteristics Information Changed'"
	task :updating_key_for_client_charateristics => :environment do
	#created by system closed manually
	user_object = User.find(1)
    AuditModule.set_current_user=(user_object)
    SystemParam.where("id = 1520 and system_param_categories_id = 9 and key = 'MANUAL_CREATED_MANUAL_CLOSE'").update_all(key: 'SYSTEM_CREATED_MANUAL_CLOSE')
	end
end
