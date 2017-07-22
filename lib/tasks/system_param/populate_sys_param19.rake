namespace :populate_sys_param19 do
	desc "Transportation Mileage Time"
	task :transportation_mileage_rates2 => :environment do
		 SystemParam.create(system_param_categories_id:13,key:"REGULAR_BUSINESS_HOUR_START_TIME",value:"06.00",description:"Week Day Regula Business Hour Start Time",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:13,key:"REGULAR_BUSINESS_HOUR_END_TIME",value:"18.00",description:"Week Day Regula Business Hour End Time",created_by: 1,updated_by: 1)
	end
end
