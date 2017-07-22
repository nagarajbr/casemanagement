namespace :update_provider_event_to_action_mapping3 do
	desc "event to action mapping for request for approval of agreement"
	task :event_to_action_mapping_for_request_for_approval => :environment do
		EventToActionsMapping.create(event_type: 690,action_type:6458,method_name:'WorkTaskService.complete_work_task',sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y',task_type: 6459)
	end
end
