namespace :populate_events_to_actions_data21 do
	desc "adding client model field change attributes to ruby elements"
	task :populate_events_to_actions_data21 => :environment do
		type = 6368

		ruby_element = RubyElement.create(element_name:"IncomeDetail",element_title:"net_amt", element_type: type, description:"Net Amount")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"ResourceDetail",element_title:"resource_value", element_type: type, description:"Resource value")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Address",element_title:"address_line1", element_type: type, description:"Address Line1")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Address",element_title:"address_line2", element_type: type, description:"Address Line2")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Address",element_title:"city", element_type: type, description:"City")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Address",element_title:"state", element_type: type, description:"Satet")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Address",element_title:"zip", element_type: type, description:"Zip")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"Address",element_title:"zip_suffix", element_type: type, description:"Zip Suffix")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2142 ,created_by: 1,updated_by: 1)
	end
end
