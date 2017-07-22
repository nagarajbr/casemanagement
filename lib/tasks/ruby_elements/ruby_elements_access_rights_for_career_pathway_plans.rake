namespace :ruby_elements_access_rights_for_career_pathway_plans  do
	desc "cpp ruby elemts and access rights "
	task :cpp_access_rights  => :environment do



        #291 - Delete button modified to Request for Approval
        RubyElement.find(291).update(element_title: "Request for Approval")


        #access rights

        AccessRight.create(role_id:2, ruby_element_id: 291,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: 291,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: 291,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: 291,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 291,    access:'Y', created_at: Time.now, updated_at: Time.now)


        ruby_object = RubyElement.create(element_name:"CareerPathwayPlansController",element_title:"Approve", element_type: 6351)

        AccessRight.create(role_id:2, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)


        ruby_object = RubyElement.create(element_name:"CareerPathwayPlansController",element_title:"Reject", element_type: 6351)

        AccessRight.create(role_id:2, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)

        # access rights for 289-new and 290-edit
        AccessRight.create(role_id:6, ruby_element_id: 289,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 290,    access:'Y', created_at: Time.now, updated_at: Time.now)





	end
end