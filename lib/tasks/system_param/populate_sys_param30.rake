namespace :populate_sys_param30 do
	desc "additional_sanction type to implication mapping"
	task :add_sanction_type_implication_mapping => :environment do

		SystemParam.create(system_param_categories_id:19,key:"6349",value:"6111",description:"Refusal to sign PRA by minor parent(6349) will show 25% benefit reduction(6111)",created_by: 1,updated_by: 1)
	end
end