namespace :populate_sys_param72 do
	desc "Different Salary/wages income types"
	task :salary_wages_income_types => :environment do

		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		SystemParam.create(system_param_categories_id: 9,key:"INCOME_TYPE_SALARY_WAGES",value:"2811",description:"Salary/Wages",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"INCOME_TYPE_SALARY_WAGES",value:"2854",description:"Salary/ Wages Conversion",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"INCOME_TYPE_SALARY_WAGES",value:"2825",description:"Salary/Wages OJT",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"INCOME_TYPE_SALARY_WAGES",value:"2790",description:"Salary Wages OJT/WIA",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"INCOME_TYPE_SALARY_WAGES",value:"2796",description:"Salary/Wages Paid Work Experience",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"INCOME_TYPE_SALARY_WAGES",value:"2829",description:"Salary/Wages Subsidized",created_by:1,updated_by: 1)
	end
end



