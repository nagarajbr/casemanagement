namespace :populate_events_to_actions_data33 do
	desc "event to action mappings entries for client date of birth change ed entry"
	task :populate_events_to_actions_data33 => :environment do
		EventToActionsMapping.create(event_type:755,action_type:6525,method_name:"ClientEntityService.eligibility_determination",sort_order:60,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end