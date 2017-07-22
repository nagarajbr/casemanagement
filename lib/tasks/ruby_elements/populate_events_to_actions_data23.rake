namespace :populate_events_to_actions_data23 do
	desc "Events to Actions Mapping Data23"
	task :populate_events_to_actions_data23 => :environment do
		# "address_line1"
		EventToActionsMapping.create(event_type:762,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:762,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:762,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:762,action_type:6525,method_name:"ClientEntityService.living_arrangement",sort_order:40,created_by: 1,updated_by: 1)

		# "address_line2"
		EventToActionsMapping.create(event_type:763,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:763,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:763,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:763,action_type:6525,method_name:"ClientEntityService.living_arrangement",sort_order:40,created_by: 1,updated_by: 1)

		# "city"
		EventToActionsMapping.create(event_type:764,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:764,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:764,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:764,action_type:6525,method_name:"ClientEntityService.living_arrangement",sort_order:40,created_by: 1,updated_by: 1)

		# "state"
		EventToActionsMapping.create(event_type:765,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:765,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:765,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:765,action_type:6525,method_name:"ClientEntityService.living_arrangement",sort_order:40,created_by: 1,updated_by: 1)

		# "zip"
		EventToActionsMapping.create(event_type:766,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:766,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:766,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:766,action_type:6525,method_name:"ClientEntityService.living_arrangement",sort_order:40,created_by: 1,updated_by: 1)

		# "zip_suffix"
		EventToActionsMapping.create(event_type:767,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:767,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:767,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:767,action_type:6525,method_name:"ClientEntityService.living_arrangement",sort_order:40,created_by: 1,updated_by: 1)
	end
end