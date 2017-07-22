namespace :populate_sys_param94 do
	desc "State holidays for 2016"
	task :state_holidays_parameters => :environment do
         user_object = User.find(1)
    	 AuditModule.set_current_user=(user_object)

		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-01-01",description:"New Year Day",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-01-18",description:"Dr. Martin Luther King Jr. and Robert E. Lee Birthdays Observed",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-02-15",description:"George Washington Birthday and Daisy Gatson Bates Day",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-05-30",description:"Memorial Day Observed",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-07-04",description:"Independence Day",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-09-05",description:"Labor Day",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-11-11",description:"Veterans Day",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-11-24",description:"Thanksgiving Day",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-12-23",description:"Christmas Eve",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:29,key:"Holiday",value:"2016-12-26",description:"Christmas Day",created_by: 1,updated_by: 1)
		end
	end