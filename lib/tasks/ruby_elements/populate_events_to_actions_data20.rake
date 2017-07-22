namespace :populate_events_to_actions_data20 do
	desc "adding client model field change attributes to ruby elements"
	task :populate_events_to_actions_data20 => :environment do
		type = 6368

		ruby_element = RubyElement.create(element_name:"Client",element_title:"first_name", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"last_name", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"middle_name", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"suffix", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"ssn", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"dob", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"gender", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"citizenship", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"marital_status", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Client",element_title:"death_date", element_type: type, description:"")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)
	end
end
