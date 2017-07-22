namespace :populate_events_to_actions_data64 do
	desc "event to action mappings entries provider registration queue"
	task :populate_events_to_actions_data64 => :environment do
		RubyElement.where("id = 537").update_all(element_title: 'Save')
		EventToActionsMapping.create(event_type:537,action_type:6586,method_name:"QueueService.create_queue",sort_order:10,queue_type:6580 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end