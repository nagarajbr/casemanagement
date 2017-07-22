namespace :populate_sys_param63 do
		desc "Benifit members status"
		task :tea_workpays_and_tea_division_member_status_drop_down=> :environment do

			# 4468 "Active"
	        # 4469 "Inactive Partial"
			# 4470 "Inactive Full"
			# 4471 "Inactive Closed"
			# system_param_categories_id: 9 = General Application Parameters
               # TEA
                    SystemParam.create(system_param_categories_id: 9,key:"1",value:"4468",description:"Active",created_by: 1,updated_by: 1)
                    SystemParam.create(system_param_categories_id: 9,key:"1",value:"4470",description:"Inactive Full",created_by: 1,updated_by: 1)
                    SystemParam.create(system_param_categories_id: 9,key:"1",value:"4471",description:"Inactive Closed",created_by: 1,updated_by: 1)

              # workpays
                    SystemParam.create(system_param_categories_id: 9,key:"4",value:"4468",description:"Active",created_by: 1,updated_by: 1)
                    SystemParam.create(system_param_categories_id: 9,key:"4",value:"4471",description:"Inactive Closed",created_by: 1,updated_by: 1)
                    SystemParam.create(system_param_categories_id: 9,key:"4",value:"4469",description:"Inactive Partial",created_by: 1,updated_by: 1)

               #tea-division
                    SystemParam.create(system_param_categories_id: 9,key:"3",value:"4468",description:"Active",created_by: 1,updated_by: 1)
                    SystemParam.create(system_param_categories_id: 9,key:"3",value:"4470",description:"Inactive Full",created_by: 1,updated_by: 1)
                    SystemParam.create(system_param_categories_id: 9,key:"3",value:"4471",description:"Inactive Closed",created_by: 1,updated_by: 1)


	    end
end


