namespace :ruby_elements_access_rights_for_service_authorization_line_items  do
	desc "service authorization line items ruby elemts and access rights "
	task :service_authorization_line_items_access_rights  => :environment do



        #618 - Delete button modified to Request for Approval
        #729- submit button modified to Approve
        RubyElement.find(618).update(element_title: "Request for Approval")
        #access rights
        AccessRight.create(role_id:2, ruby_element_id: 618,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: 618,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: 618,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: 618,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 618,    access:'Y', created_at: Time.now, updated_at: Time.now)

        RubyElement.find(729).update(element_title: "Approve")
        #access rights
        AccessRight.create(role_id:2, ruby_element_id: 729,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: 729,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: 729,    access:'Y', created_at: Time.now, updated_at: Time.now)

        ruby_object = RubyElement.create(element_name:"ServiceAuthorizationLineItemsController",element_title:"Reject", element_type: 6351)
        #access rights
        AccessRight.create(role_id:2, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)


        ruby_object = RubyElement.create(element_name:"ServiceAuthorizationLineItemsController",element_title:"New_non_transportation", element_type: 6351)

        AccessRight.create(role_id:2, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)

       ruby_object = RubyElement.create(element_name:"ServiceAuthorizationLineItemsController",element_title:"edit_non_transportation", element_type: 6351)

        AccessRight.create(role_id:2, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)


	end
end