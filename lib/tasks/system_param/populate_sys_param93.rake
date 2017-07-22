namespace :populate_sys_param93 do
	desc "State holidays for 2016"
	task :state_holidays => :environment do
         user_object = User.find(1)
    	 AuditModule.set_current_user=(user_object)
         systemparamcategories = SystemParamCategory.create(description:"State Holidays",created_by: 1,updated_by: 1)
	end
end
