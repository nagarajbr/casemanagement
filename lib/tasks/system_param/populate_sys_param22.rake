namespace :populate_sys_param22 do
	desc "Barriers To Action/Service Mapping"
	task :barrier_action_service_mapping => :environment do
		systemParamCategories = SystemParamCategory.create(description:"Barriers To Action/Service Mapping",created_by: 1,updated_by: 1)
		# EMPLOYMENT_PLAN_ACTIONS
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6278",description:"Barrier = Employment Barrier, One of the Action may be -Participate in community service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6277",description:"Barrier = Employment Barrier, One of the Action may be -Submit Job Search Daily Logs to Case Manager",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6315",description:"Barrier = Employment Barrier, One of the Action may be -Participate in job search - self",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6316",description:"Barrier = Employment Barrier, One of the Action may be -Participate in unsubsidized employment",created_by: 1,updated_by: 1)

		# EMPLOYMENT_PLAN_SERVICES
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6289",description:"Barrier = Employment Barrier, One of the Service may be -Receive job search Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6284",description:"Barrier = Employment Barrier, One of the Service may be -Participate in Attend Job Readiness Workshop	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6293",description:"Barrier = Employment Barrier, One of the Service may be -Participate in Work Experience Placement	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6291",description:"Barrier = Employment Barrier, One of the Service may be  Participate in on-the-Job Training Placement	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6326",description:"Barrier = Employment Barrier, One of the Service may be -Receive Two-year Degree Program	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6327",description:"Barrier = Employment Barrier, One of the Service may be -Receive Advanced Degree Program	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6321",description:"Barrier = Employment Barrier, One of the Service may be -Receive Bachelor's Degree Program	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6322",description:"Barrier = Employment Barrier, One of the Service may be -Participate in subsidized public employment	Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"EMPLOYMENT_PLAN_SERVICES",value:"6323",description:"Barrier = Employment Barrier, One of the Service may be -Participate in subsidized private employment	Service",created_by: 1,updated_by: 1)



		# BARRIER_REDUCTION_PLAN_ACTIONS
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"BARRIER_REDUCTION_PLAN_ACTIONS",value:"6317",description:"Barrier = Non Employment,One of the Action may be - Participate in High School/GED Certificate Program",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"BARRIER_REDUCTION_PLAN_ACTIONS",value:"6318",description:"Barrier = Non Employment,One of the Action may be - Referral for learning needs",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"BARRIER_REDUCTION_PLAN_ACTIONS",value:"6319",description:"Barrier = Non Employment,One of the Action may be - Enroll child(ren) in child care",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"BARRIER_REDUCTION_PLAN_ACTIONS",value:"6320",description:"Barrier = Non Employment,One of the Action may be - Enroll child(ren) in special needs child care",created_by: 1,updated_by: 1)

		# BARRIER_REDUCTION_PLAN_SERVICES
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6292",description:"Barrier = Employment Barrier, One of the Service may be -Gain Work Experience through Vocational Education Service",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6287",description:"Barrier = Employment Barrier, One of the Service may be -Participate in ESL Program	Service",created_by: 1,updated_by: 1)

	end
end