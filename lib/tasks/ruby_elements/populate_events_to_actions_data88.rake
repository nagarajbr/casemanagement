namespace :populate_events_to_actions_data88  do
	desc "add event to action mapping for sanctions details"
	task :populate_events_to_actions_data88  => :environment do

		EventToActionsMapping.create(event_type: 834,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:2168 ,enable_flag: 'Y',created_by: 1,updated_by: 1)
   end
end