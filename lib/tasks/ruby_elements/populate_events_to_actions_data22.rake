namespace :populate_events_to_actions_data22 do
	desc "Events to Actions Mapping Data22"
	task :populate_events_to_actions_data22 => :environment do
		# "First Name"
		EventToActionsMapping.create(event_type:750,action_type:6517,method_name:"ClientEntityService.ssn_enumeration",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:750,action_type:6518,method_name:"ClientEntityService.citizenship_verification",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:750,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:40,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:750,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:50,created_by: 1,updated_by: 1)

		# "Last name"
		EventToActionsMapping.create(event_type:751,action_type:6517,method_name:"ClientEntityService.ssn_enumeration",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:751,action_type:6518,method_name:"ClientEntityService.citizenship_verification",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:751,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:40,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:751,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:50,created_by: 1,updated_by: 1)

		# "Middle Name"
		EventToActionsMapping.create(event_type:752,action_type:6517,method_name:"ClientEntityService.ssn_enumeration",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:752,action_type:6518,method_name:"ClientEntityService.citizenship_verification",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:752,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:40,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:752,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:50,created_by: 1,updated_by: 1)

		# "Suffix"
		EventToActionsMapping.create(event_type:753,action_type:6517,method_name:"ClientEntityService.ssn_enumeration",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:753,action_type:6518,method_name:"ClientEntityService.citizenship_verification",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:753,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:40,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:753,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:50,created_by: 1,updated_by: 1)

		# "SSN"
		EventToActionsMapping.create(event_type:754,action_type:6517,method_name:"ClientEntityService.ssn_enumeration",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:754,action_type:6518,method_name:"ClientEntityService.citizenship_verification",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:754,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:40,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:754,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:50,created_by: 1,updated_by: 1)

		# "Dob"
		EventToActionsMapping.create(event_type:755,action_type:6517,method_name:"ClientEntityService.ssn_enumeration",sort_order:20,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:755,action_type:6518,method_name:"ClientEntityService.citizenship_verification",sort_order:30,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:755,action_type:6519,method_name:"ClientEntityService.ocse_referral",sort_order:40,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:755,action_type:6520,method_name:"ClientEntityService.ebt",sort_order:50,created_by: 1,updated_by: 1)
	end
end