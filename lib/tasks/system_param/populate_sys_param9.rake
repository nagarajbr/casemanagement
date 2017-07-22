namespace :populate_sys_params9 do
	desc "Guardian_Inverse_relationship"
	task :guardian_inverse_relationship => :environment do
		SystemParam.create(system_param_categories_id: 5,key:"6097",value:"6098",description:"Inverse relation for Guardian is- dependent/ward",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id: 5,key:"6098",value:"6097",description:"Inverse relation for Dependent/Ward is- Guardian",created_by: 1,updated_by: 1)

	end
end



