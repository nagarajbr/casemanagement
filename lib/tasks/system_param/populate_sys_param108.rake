namespace :populate_sys_param108 do
	desc "provider services with occupations"
	task :provider_services_with_occupation => :environment do
	user_object = User.find(1)
    AuditModule.set_current_user=(user_object)

    SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6222",description:"Provide Wage subsidy paid to employer",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6284",description:"Provide Job Readiness Workshop Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6285",description:"Provide Life Skills Training Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6286",description:"Provide Work Experience through Vocational Education Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6287",description:"Provide ESL Program Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6289",description:"Provide Job Search placement Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6290",description:"Provide Literacy Program Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6291",description:"Provide on-the-Job Training Placement Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6292",description:"Provide Vocational Certification/Licensure Program Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6293",description:"Provide Work Experience Placement Service",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6321",description:"Bachelors Degree Program",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6322",description:"Subsidised public employment",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6323",description:"Subsidised private employment",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6324",description:"Vocational Rehabilitation",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6326",description:"Two-year Degree Program",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6327",description:"Advanced Degree Program",created_by: 1,updated_by: 1)
	SystemParam.create(system_param_categories_id: 9,key:"PROVIDER_SERVICES_WITH_OCCUPATION",value:"6722",description:"Health Information Certificate",created_by: 1,updated_by: 1)


   end
end