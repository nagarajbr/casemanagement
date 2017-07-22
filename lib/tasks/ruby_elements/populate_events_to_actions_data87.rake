namespace :populate_events_to_actions_data87  do
	desc "populate event to action mapping for end date in sanctions"
	task :populate_events_to_actions_data87  => :environment do

		EventToActionsMapping.create(event_type: 730,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:2168 ,enable_flag: 'Y',created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type: 730,action_type:6630,method_name:'QueueService.delete_queue',sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6642)

   end
end