namespace :populate_events_to_actions_data93  do
	desc "add an event to action mapping for Initiate application process button in prescreening"
	task :populate_events_to_actions_data93  => :environment do

		EventToActionsMapping.create(event_type:846,action_type:6586,method_name:"QueueService.create_queue",sort_order:10,queue_type:6717 ,created_by: 1,updated_by: 1,enable_flag: 'Y')

   end
end