namespace :populate_sys_param11 do
	desc "Application screening days limit"
	task :app_screening_limit => :environment do

		SystemParam.create(system_param_categories_id: 9,key:"APP_SCREENING_DAYS_LIMIT",value:"30",description:"Application Screening should be completed within 30 days of application date.",created_by: 1,updated_by: 1)
	end

end