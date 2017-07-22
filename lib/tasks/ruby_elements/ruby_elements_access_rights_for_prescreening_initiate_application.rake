namespace :ruby_elements_access_rights_initiate_application_button  do
        desc "prescreening initiate application button"
        task :initiate_appication_process  => :environment do

                ruby_object = RubyElement.create(element_name:"/prescreen_household",element_title:"Save", element_type: 6351)

                #ruby_element_reltns
                RubyElementReltn.create(parent_element_id: 3,child_element_id: ruby_object.id, child_order: 10)

                #access rights
                AccessRight.create(role_id:3, ruby_element_id: ruby_object.id, access:'Y', created_at: Time.now, updated_at: Time.now)
                AccessRight.create(role_id:5, ruby_element_id: ruby_object.id, access:'Y', created_at: Time.now, updated_at: Time.now)
                AccessRight.create(role_id:6, ruby_element_id: ruby_object.id, access:'Y', created_at: Time.now, updated_at: Time.now)
        end
end