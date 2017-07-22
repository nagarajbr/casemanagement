namespace :populate_sys_param86 do
	desc "Mapping queues to task types"
	task :queues_to_task_types => :environment do
		user_object = User.find(1)
    	AuditModule.set_current_user=(user_object)
		systemParamCategory = SystemParamCategory.create(description:"Mapping queues to task types",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6735",value:"6736",description:"Applications Queue",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6557",value:"6593",description:"Ready for Application Processing",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6558",value:"6346",description:"Ready for Eligibility Determination",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6559",value:"6387",description:"Ready for Work Readiness Assessment",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6560",value:"6605",description:"Ready for Employment Readiness planning",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6637",value:"6607",description:"Ready for Career Pathway Planning Approval",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategory.id,key:"6562",value:"2172",description:"Ready for Program Unit Activation",created_by: 1,updated_by: 1)
	end
end