namespace :ruby_elements_access_rights_for_work_flow_status  do
	desc "work flow status ruby element , relation and access right are created "
	task :ruby_elements_access_rights_for_work_flow_status  => :environment do
		level_1_menu = RubyElement.find(65)
		level_2_menu = RubyElement.create(element_name:"work_flow_status/show/:program_unit_id",element_title:"Work Flow Status", element_type: 6350, element_microhelp:"work_flow_status")

       RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 20)

			user_role_id = 6 # Manager
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 5 # Supervisor
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
			user_role_id = 3 #  specialist
					AccessRight.create(role_id: user_role_id, ruby_element_id: level_2_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

    end
end