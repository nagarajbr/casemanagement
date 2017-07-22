namespace :populate_events_to_actions_data99 do
	desc "event to actions mappings for ed queue"
	task :populate_events_to_actions_data99 => :environment do
		EventToActionsMapping.where("event_type = 243 and action_type = 6586").update_all(queue_type: 6557)
		ruby_element = RubyElement.create(element_name:"ApplicationProcessingController",element_title:"last_step_apply_button", element_type: 6351, description:"create new application")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6586,method_name:"QueueService.create_queue",sort_order:10,created_by: 1,updated_by: 1,queue_type: 6558,enable_flag: 'Y')
		EventToActionsMapping.where("event_type = 243 and action_type = 6458").update_all(task_type: 6736)
	end
end
