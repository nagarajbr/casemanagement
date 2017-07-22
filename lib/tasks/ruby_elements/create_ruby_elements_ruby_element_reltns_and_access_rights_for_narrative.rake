namespace :create_ruby_elements_ruby_element_reltns_and_access_rights_for_narrative  do
	desc "create ruby elements ruby element reltns and access rights for narrative "
	task :create_ruby_elements_ruby_element_reltns_and_access_rights_for_narrative  => :environment do


      ruby_element_relation = RubyElementReltn.create(parent_element_id: 138 ,child_element_id:772, child_order: 10)
      ruby_element_relation.destroy



      ruby_element = RubyElement.create(element_name:"/narative/index",element_title:"Narrative", element_type: 6350, element_microhelp: "narative",element_help_page: "CL")
      ruby_element_relation = RubyElementReltn.create(parent_element_id: 4,child_element_id:ruby_element.id, child_order: 15)
      RubyElementReltn.where("id =225").update_all(parent_element_id:ruby_element.id ,child_order: 10)


       #access Rights
       AccessRight.create(role_id:2, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:7, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:8, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:12, ruby_element_id: ruby_element.id,    access:'Y', created_at: Time.now, updated_at: Time.now)




	end
end


