namespace :update_provider_event_to_action_mapping2 do
	desc "event to action mapping for save button"
	task :event_to_action_mapping_for_reject_agreement  => :environment do

		EventToActionsMapping.where("event_type = 691 and action_type = 6446 and task_type = 6603").destroy_all

		EventToActionsMapping.create(event_type: 691,action_type:6630,method_name:'QueueService.delete_queue',sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6640)
	end
end
