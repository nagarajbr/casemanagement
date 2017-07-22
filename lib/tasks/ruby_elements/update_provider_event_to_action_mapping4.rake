namespace :update_provider_event_to_action_mapping4 do
	desc "event to action mapping for approve button"
	task :event_to_action_mapping_for_approve_button  => :environment do
		EventToActionsMapping.create(event_type: 687,action_type:6630,method_name:'QueueService.delete_queue',sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6640)
	end
end
