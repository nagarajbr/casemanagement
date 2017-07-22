namespace :populate_events_to_actions_data97  do
	desc "add event to action mapping submit payment button"
	task :populate_events_to_actions_data97  => :environment do

		EventToActionsMapping.create(event_type: 618,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:6470 ,enable_flag: 'Y',created_by: 1,updated_by: 1)
   end
end