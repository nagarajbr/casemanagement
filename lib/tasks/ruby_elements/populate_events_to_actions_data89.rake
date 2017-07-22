namespace :provider_event_to_action_mapping89 do
	desc "event to action mapping for request for approval of agreement"
	task :add_event_to_action_mapping_for_request_for_approval => :environment do
		EventToActionsMapping.create(event_type: 690,action_type:6445,method_name:'WorkTaskService.create_work_task',sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y',task_type: 6353)
	end
end
