namespace :populate_events_to_actions_data82 do
	desc "event to action mappings complete cpp"
	task :populate_events_to_actions_data82 => :environment do
		ruby_element_object = RubyElement.create(element_name: 'CareerPathwayPlansController',element_title:'Complete CPP',element_type:6351)

		EventToActionsMapping.create(event_type:ruby_element_object.id,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6605 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element_object.id,action_type:6586,method_name:"QueueService.create_queue",sort_order:20,queue_type:6637 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end

