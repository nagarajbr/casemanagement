namespace :create_ruby_elements_and_application_access_rights_for_work_task do
	desc "create ruby elements and application access rights for work task category"
	task :create_ruby_elements_and_application_access_rights => :environment do


	ruby_element = RubyElement.create(element_name:"6366",element_title:"Client", element_type: 6737, element_microhelp: "ARWINS")
		ApplicationAccessRight.create(application_id:6739, ruby_element_id:	ruby_element.id	,  access:'Y', created_at: Time.now, updated_at: Time.now)

	ruby_element = RubyElement.create(element_name:"6200",element_title:"Supportive Services", element_type: 6737, element_microhelp: "ARWINS")
		ApplicationAccessRight.create(application_id:6739, ruby_element_id:	ruby_element.id	,  access:'Y', created_at: Time.now, updated_at: Time.now)

	ruby_element = RubyElement.create(element_name:"6199",element_title:"TEA Diversion", element_type: 6737, element_microhelp: "ARWINS")
		ApplicationAccessRight.create(application_id:6739, ruby_element_id:	ruby_element.id	,  access:'Y', created_at: Time.now, updated_at: Time.now)

	ruby_element = RubyElement.create(element_name:"6198",element_title:"Work pays", element_type: 6737, element_microhelp: "ARWINS")
		ApplicationAccessRight.create(application_id:6739, ruby_element_id:	ruby_element.id	,  access:'Y', created_at: Time.now, updated_at: Time.now)

	ruby_element = RubyElement.create(element_name:"6197",element_title:"TEA", element_type: 6737, element_microhelp: "ARWINS")
		ApplicationAccessRight.create(application_id:6739, ruby_element_id:	ruby_element.id	,  access:'Y', created_at: Time.now, updated_at: Time.now)

	ruby_element = RubyElement.create(element_name:"6352",element_title:"Provider", element_type: 6737, element_microhelp: "PROVIDER")
		ApplicationAccessRight.create(application_id:6740, ruby_element_id:	ruby_element.id	,  access:'Y', created_at: Time.now, updated_at: Time.now)
	end
end
