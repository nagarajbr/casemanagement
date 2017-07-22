namespace :ruby_elements_access_rights_for_provider_invoices  do
	desc "provider_invoices ruby elemts and access rights "
	task :provider_invoices_ruby_elements_access_rights  => :environment do


        RubyElement.find(692).update(element_title: "Release")

        AccessRight.where("ruby_element_id = 692 and id = 3722").update_all("access = 'N'")
        AccessRight.create(role_id:6, ruby_element_id: 692, access:'Y', created_at: Time.now, updated_at: Time.now)

        RubyElement.find(549).update(element_title: "Deny")

        AccessRight.where("ruby_element_id = 549 and id in (1985,3721,2496)").update_all("access = 'N'")
        AccessRight.create(role_id:6, ruby_element_id: 549, access:'Y', created_at: Time.now, updated_at: Time.now)

        ruby_object = RubyElement.create(element_name:"ProviderInvoicesController",element_title:"Request for Approval", element_type: 6351)

        AccessRight.create(role_id:2, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:3, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:4, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:5, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)
        AccessRight.create(role_id:6, ruby_element_id: ruby_object.id,    access:'Y', created_at: Time.now, updated_at: Time.now)





	end
end