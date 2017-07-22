namespace :populate_events_to_actions_data42 do
	desc "event to action mappings entries for relationship add and delete"
	task :populate_events_to_actions_data42 => :environment do
		type = 6368
		EventToActionsMapping.create(event_type:343,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:343,action_type:6525,method_name:"ClientEntityService.ed_entry_for_relationship",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:345,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:345,action_type:6525,method_name:"ClientEntityService.ed_entry_for_relationship",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end