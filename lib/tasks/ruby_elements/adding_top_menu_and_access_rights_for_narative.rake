namespace :adding_top_menu_and_access_rights_for_narative do
	desc "This is a template to create menu item and access rights for narative"
	task :adding_top_menu_and_access_rights_for_narative => :environment do


        level_1_menu = RubyElement.find(5) # profile
		level_2_menu = RubyElement.create(element_name:"/narative/index",element_title:"Narrative", element_type: 6350, element_microhelp:"narative")
			RubyElementReltn.create(parent_element_id: level_1_menu.id,child_element_id: level_2_menu.id, child_order: 70)

	    AccessRight.create(role_id:2, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:7, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:8, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:9, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:10, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:11, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:12, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:13, ruby_element_id: level_2_menu.id,    access:'Y', created_at: Time.now, updated_at: Time.now)



	end
end