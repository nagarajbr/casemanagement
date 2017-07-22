namespace :populate_sys_param28 do
	desc "Sanction type add delete"
	task :sanction_type_add_delete => :environment do
		SystemParam.where("system_param_categories_id = 9 and key='BENEFIT_REDUCING_SANCTIONS' and value = '4578'").update_all(value:"3082")
		SystemParam.create(system_param_categories_id: 9,key:"BENEFIT_REDUCING_SANCTIONS",value:"6349",description:"Refusal to sign PRA by minor parent sanction",created_by: 1,updated_by: 1)
	end
end
