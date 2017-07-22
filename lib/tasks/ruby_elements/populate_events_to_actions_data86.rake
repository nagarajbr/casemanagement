namespace :populate_events_to_actions_data86  do
	desc "Update event to action mapping for new action in sanctions"
	task :populate_events_to_actions_data86  => :environment do

		EventToActionsMapping.create(event_type:595,action_type:6586,method_name:"QueueService.create_queue",sort_order:30,queue_type:6642 ,created_by: 1,updated_by: 1,enable_flag: 'Y')

   end
end