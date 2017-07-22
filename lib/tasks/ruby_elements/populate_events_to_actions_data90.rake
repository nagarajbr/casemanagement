namespace :populate_events_to_actions_data90 do
	desc "event to actions mappings for assis verification"
	task :populate_events_to_actions_data90 => :environment do
		EventToActionsMapping.create(event_type:537,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end
