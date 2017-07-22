namespace :populate_events_to_actions_data45 do
	desc "event to action mappings entries rejecting an application"
	task :populate_events_to_actions_data45 => :environment do
		EventToActionsMapping.create(event_type:243,action_type:6574,method_name:"ClientEntityService.notice_for_rejecting_an_aplication",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end