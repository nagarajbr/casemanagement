namespace :update_event_to_action_to_add_alien_actions do
	desc "event to actions mappings for alien"
	task :update_event_to_action_to_add_alien_actions => :environment do
		EventToActionsMapping.create(event_type: 814,action_type:6525,method_name:"ClientEntityService.ed_entry_for_non_citizenship_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type: 815,action_type:6525,method_name:"ClientEntityService.ed_entry_for_non_citizenship_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end
