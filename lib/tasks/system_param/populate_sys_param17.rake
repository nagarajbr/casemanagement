namespace :populate_sys_param17 do
	desc "Transportation Mileage Rates"
	task :transportation_mileage_rates => :environment do
		 systemParamCategories = SystemParamCategory.create(description:"Transportation Mileage Rates",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"REGULAR",value:"15.00",description:"$15.00 Flat Rate plus state mileage reimbursement rate per mile for distance traveled,Any trip that originates after 6 am or before 6 pm - Monday through Friday",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WEEK_NIGHT",value:"20.00",description:" $20.00 flat rate plus current state mileage reimbursement rate per mile for distance traveled - Any trip that originates before 6 am or after 6 pm - Monday through Friday",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"WEEKEND",value:"25.00",description:" $25.00 flat rate plus current state mileage reimbursement rate per mile for distance traveled - Any trip that originates after 6 pm on Friday through 6 am on Monday",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"NO_SHOWS",value:"15.00",description:" $15.00 Flat Rate",created_by: 1,updated_by: 1)
		 SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"STATE_MILEAGE_RATE",value:"0.42",description:"year-2014- State Mileage rate per mile",created_by: 1,updated_by: 1)
	end
end




