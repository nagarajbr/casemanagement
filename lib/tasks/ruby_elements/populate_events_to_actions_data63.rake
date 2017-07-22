namespace :events_to_actions_mapping63 do
	desc "Events to Actions Mapping for Assigning queue task"
	task :events_to_actions_mapping63 => :environment do
		ruby_element = RubyElement.create(element_name:"WorkQueuesController",element_title:"Assign to me", element_type: 6351, description:"Assign to me")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type: 6621,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end