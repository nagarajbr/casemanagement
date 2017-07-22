namespace :populate_events_to_actions_data98 do
	desc "event to actions mappings for application queue"
	task :populate_events_to_actions_data98 => :environment do
		ruby_element = RubyElement.create(element_name:"ApplicationProcessingController",element_title:"step1_next_creating_new_application", element_type: 6351, description:"create new application")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6586,method_name:"QueueService.create_queue",sort_order:10,created_by: 1,updated_by: 1,queue_type: 6735,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6458,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6736 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type: 243,action_type:6630,method_name:'QueueService.delete_queue',sort_order:40,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6735)
	end
end
