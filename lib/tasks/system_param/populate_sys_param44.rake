namespace :populate_sys_param44 do
	desc "Additional Mapping of Roles to Work Types "
	task :role_to_approve_pgu_work_type => :environment do
		# Worktype to days key value pairs
		SystemParam.create(system_param_categories_id:24,key:"2",value:"2172",description:"Role(2)-System Support can see work type(2172)-Approve Program Unit",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:24,key:"5",value:"2172",description:"Role(5)-Supervisor can see work type(2172)-Approve Program Unit",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:24,key:"6",value:"2172",description:"Role(6)-Manager can see work type(2172)-Approve Program Unit",created_by: 1,updated_by: 1)
	end
end