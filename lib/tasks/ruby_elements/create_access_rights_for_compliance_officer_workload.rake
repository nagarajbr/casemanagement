namespace :create_access_rights_for_compliance_officer_workload do
	desc "Creating access rights for compliance officer for workload  "
	task :create_access_rights_for_compliance_officer_workload => :environment do
		user_role_id = 12 # compliance officer
		# AccessRight.create(role_id: user_role_id, ruby_element_id: level_1_menu.id,  access:'Y', created_at: Time.now, updated_at: Time.now)
		AccessRight.create(role_id: user_role_id, ruby_element_id: 715,  access:'Y', created_at: Time.now, updated_at: Time.now)#"Alerts"
		AccessRight.create(role_id: user_role_id, ruby_element_id: 716,  access:'Y', created_at: Time.now, updated_at: Time.now)#"Alerts" 						AccessRight.create(role_id: user_role_id, ruby_element_id: 717,  access:'Y', created_at: Time.now, updated_at: Time.now)#"My Program Units"
		AccessRight.create(role_id: user_role_id, ruby_element_id: 718,  access:'Y', created_at: Time.now, updated_at: Time.now)#"My Program Units"
        AccessRight.create(role_id: user_role_id, ruby_element_id: 719,  access:'Y', created_at: Time.now, updated_at: Time.now)#"my_applications"
		AccessRight.create(role_id: user_role_id, ruby_element_id: 720,  access:'Y', created_at: Time.now, updated_at: Time.now)#"my_applications"
  #       AccessRight.create(role_id: user_role_id, ruby_element_id: 721,  access:'Y', created_at: Time.now, updated_at: Time.now)#"search_work_tasks"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 722,  access:'Y', created_at: Time.now, updated_at: Time.now)#"search_work_tasks"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 135,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "Workload Management"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 136,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "My To Do List"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 137,  access:'Y', created_at: Time.now, updated_at: Time.now)   # "To Do List"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 138,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Workload Queues"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 139,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Intake Queues"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 140,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Workload Queues"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 141,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Supervisor Workspace"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 142,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Supervisor Workspace"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 143,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Interviews Management"
		# AccessRight.create(role_id: user_role_id, ruby_element_id: 144,  access:'N', created_at: Time.now, updated_at: Time.now)   # "Interviews Management"


	end
end
