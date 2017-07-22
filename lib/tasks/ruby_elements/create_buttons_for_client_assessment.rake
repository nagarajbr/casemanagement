namespace :create_buttons_for_client_assessment do
	desc "create buttons for client assessment"
	task :create_buttons_for_client_assessment => :environment do
		connection = ActiveRecord::Base.connection()
		connection.execute("SELECT setval('public.ruby_elements_id_seq', (select max(id) from public.ruby_elements), true)")
		# connection.execute("SELECT setval('public.ruby_element_reltns_id_seq', (select max(id) from public.ruby_element_reltns), true)")
		type = 6351
		# Dir[Rails.root.join('app/controllers/*_controller.rb')].map { |path| (path.match(/(\w+)_controller.rb/); $1).camelize+"Controller" }.each do |con_name|
		# 	RubyElement.create(element_name:con_name,element_title:"New", element_type: type)
		# 	RubyElement.create(element_name:con_name,element_title:"Edit", element_type: type)
		# 	RubyElement.create(element_name:con_name,element_title:"Delete", element_type: type)
		# end
		next_button_object = RubyElement.create(element_name:"ClientAssessmentAnswersController",element_title:"Next", element_type: type)
		save_button_object =RubyElement.create(element_name:"ClientAssessmentAnswersController",element_title:"Save", element_type: type)
		generate_button_object = RubyElement.create(element_name:"ClientAssessmentAnswersController",element_title:"Generate Assessment Sheet", element_type: type)

		user_role_id = 2 # System Support user

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 3 # Intake Worker

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 4 # Case Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 5 # Supervisor

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)


		user_role_id = 6 # Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 7 # QA

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'N', created_at: Time.now, updated_at: Time.now)

		user_role_id = 8 # Workload Manager

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)

		user_role_id = 12 # Compliance officer

				AccessRight.create(role_id: user_role_id, ruby_element_id: next_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: save_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
				AccessRight.create(role_id: user_role_id, ruby_element_id: generate_button_object.id,  access:'Y', created_at: Time.now, updated_at: Time.now)





	end
end
