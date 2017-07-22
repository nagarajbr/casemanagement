namespace :populate_events_to_actions_data92  do
	desc "add an event to action mapping for new action in sanctions"
	task :populate_events_to_actions_data92  => :environment do

		EventToActionsMapping.create(event_type:618,action_type:6586,method_name:"QueueService.create_queue",sort_order:20,queue_type:6654 ,created_by: 1,updated_by: 1,enable_flag: 'Y')

   end
end