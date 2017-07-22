namespace :provider_event_to_action_mapping do
	desc "event to action mapping for complete registration"
	task :event_to_action_mapping_for_complete_registration_button  => :environment do

		EventToActionsMapping.create(event_type: 839, action_type: 6586, method_name: "QueueService.create_queue", sort_order: 10, enable_flag: 'Y', queue_type: 6639,created_by: '1',updated_by: '1')

	end
end
