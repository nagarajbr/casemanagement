namespace :populate_sys_param33 do
	desc "additional Mapping of Barriers to EP and BRP"
	task :additional_barriers_ep_brp_mapping => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:17,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6328",description:"Provide Child Care Services for Participant Enrolled in Community Service is valid EP Action",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:17,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6283",description:"Submit Attendance record is valid EP Action",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:17,key:"EMPLOYMENT_PLAN_ACTIONS",value:"6357",description:"Refer to other agencies as applicable is valid EP Action",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_ACTIONS",value:"6357",description:"Refer to other agencies as applicable is valid BRP Action",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6359",description:"Vehicle Insurance activity should be dropdown for BRP Action - Transportation Challenge",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6360",description:"Vehicle Repairs activity should be dropdown for BRP Action - Transportation Challenge",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6361",description:"Vehicle Down Payment activity should be dropdown for BRP Action - Transportation Challenge",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6362",description:"Vehicle Tax/License activity should be dropdown for BRP Action - Transportation Challenge",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6286",description:"Gain Work Experience through Vocational Education",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:17,key:"BARRIER_REDUCTION_PLAN_SERVICES",value:"6324",description:"Participate in  Vocational Rehabilitation",created_by: 1,updated_by: 1)




	end
end





















