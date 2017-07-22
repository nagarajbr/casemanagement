namespace :populate_sys_param34 do
	desc "More Action/Service Mapped to Federal Components"
	task :action_service_mapping_to_federal_component2 => :environment do

		SystemParam.create(system_param_categories_id:16,key:"6286",value:"6240",description:"Gain Work Experience through Vocational Education Mapped To Federal Component Vocational Education Training (Core)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6286",value:"6250",description:"Gain Work Experience through Vocational Education Mapped To Federal Component Job Skills Training Directly Related to Employment (Non Core)",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:16,key:"6324",value:"6240",description:"Participate in  Vocational Rehabilitation Mapped To Federal Component Vocational Education Training (Core)",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6324",value:"6250",description:"Participate in  Vocational Rehabilitation Mapped To Federal Component Job Skills Training Directly Related to Employment (Non Core)",created_by: 1,updated_by: 1)


		# SystemParam.create(system_param_categories_id:16,key:"6355",value:"6267",description:"Provide Child Care Services for Participant Enrolled in Community Service  Mapped To Federal Component -  Providing child care services to a Community Service participant (Core)",created_by: 1,updated_by: 1)

		# SystemParam.create(system_param_categories_id:16,key:"6356",value:"6240",description:"Submit Attendance record  Mapped To Federal Component -  Career and Technical Education (Core)",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:16,key:"6357",value:"6358",description:"Refer to other agencies as applicable Mapped To Federal Component None",created_by: 1,updated_by: 1)


		SystemParam.create(system_param_categories_id:16,key:"6359",value:"6358",description:"Vehicle Insurance Mapped To Federal Component None",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6360",value:"6358",description:"Vehicle Repairs Mapped To Federal Component None",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6361",value:"6358",description:"Vehicle Down Payment Mapped To Federal Component None",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:16,key:"6362",value:"6358",description:"Vehicle Tax/License  Mapped To Federal Component None",created_by: 1,updated_by: 1)

		SystemParam.where("system_param_categories_id = 16 and key = '6286'").update_all(value: 6268)

		SystemParam.where("system_param_categories_id = 16 and key = '6283' and value='6250'").destroy_all
		SystemParam.where("system_param_categories_id = 16 and key = '6326' and value='6250'").destroy_all
		SystemParam.where("system_param_categories_id = 16 and key = '6327' and value='6250'").destroy_all
		SystemParam.where("system_param_categories_id = 16 and key = '6287' and value='6250'").destroy_all
		SystemParam.where("system_param_categories_id = 16 and key = '6292' and value='6250'").destroy_all
		SystemParam.where("system_param_categories_id = 16 and key = '6321' and value='6250'").destroy_all

		SystemParam.where("system_param_categories_id = 16 and key = '6286' and value='6241'").destroy_all
		SystemParam.create(system_param_categories_id:16,key:"6286",value:"6268",description:"Gain Work Experience through Vocational Education  Mapped To Education Directly Related to Employment (Non-core)",created_by: 1,updated_by: 1)

		SystemParam.create(system_param_categories_id:16,key:"6324",value:"6358",description:"Participate in  Vocational Rehabilitation  Mapped To Federal Component None",created_by: 1,updated_by: 1)








	end
end





