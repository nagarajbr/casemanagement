namespace :populate_sys_param51 do
	desc "Mapping of work characters that needs CPP"
	task :work_characters_cpp=> :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5702",description:"wp charcter:TEA Rehab-Education Track needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5703",description:"wp charcter:TEA Rehab-Employment Trac needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5667",description:"wp charcter:Mandatory needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5700",description:"wp charcter:TEA Minor Parent BU Head needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5717",description:"wp charcter:TEA Welfare to Work needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5672",description:"wp charcter: needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5701",description:"wp charcter:TEA Minor Parent School needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5698",description:"wp charcter:TEA Extnd Unable find job needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5688",description:"wp charcter:TEA Extnd Case Circumstan needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5692",description:"wp charcter:TEA Extnd Educ/Training needs CPP",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:9,key:"CPP_WORK_CHARACTERISTICS",value:"5669",description:"wp charcter:Pending Admin Hearing needs CPP",created_by: 1,updated_by: 1)

	end
end

