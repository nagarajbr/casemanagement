namespace :update_provider_event_to_action_mapping do
	desc "event to action mapping for request for approval"
	task :event_to_action_mapping_for_request_for_approval_button  => :environment do

		EventToActionsMapping.where("id = 4 and event_type = 690").update_all("action_type = 6586, method_name = 'QueueService.create_queue', queue_type = 6640")

	end
end
