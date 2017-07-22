namespace :populate_sys_param96 do
	desc "Different Salary/wages income types"
	task :earned_income_types => :environment do

		 user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2811",description:"Salary/Wages",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2825",description:"Salary/Wages OJT",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2790",description:"Salary Wages OJT/WIA",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2796",description:"Salary/Wages Paid Work Experience",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2829",description:"Salary/Wages Subsidized",created_by:1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2651",description:"Self-Employed Farm/Ranch",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2681",description:"Military Off Base Allowan",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2687",description:"Flea Market",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2689",description:"Severance Pay",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2703",description:"Internship",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2708",description:"Tips",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2721",description:"Americorps/NCCC Living Al",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2725",description:"Americorps/USA Living All",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2727",description:"Bonus/Incentive",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2728",description:"Blood/Plasma Sales",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2732",description:"Commission",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2749",description:"Delta Service Corp NCSA",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2764",description:"Experience Works Program",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2774",description:"Jobs Corps Allowance",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2775",description:"Workforce Investment Act",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2797",description:"Self-Employed Room/Board ",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2821",description:"Self-Employed-Other ",created_by:1,updated_by: 1)

		SystemParam.create(system_param_categories_id: 9,key:"EARNED_INCOME_TYPES",value:"2822",description:"Sick Pay-Employer ",created_by:1,updated_by: 1)


	end
end