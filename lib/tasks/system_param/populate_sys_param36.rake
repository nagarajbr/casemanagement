namespace :populate_sys_param36 do
	desc "More Action/Service Mapped to Federal Components"
	task :action_service_mapping_to_federal_component2 => :environment do
		SystemParam.create(system_param_categories_id:16,key:"6318",value:"6358",description:"Referral for learning needs mapped To Federal Component None",created_by: 1,updated_by: 1)

	end
end
