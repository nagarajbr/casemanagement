namespace :populate_events_to_actions_data40 do
	desc "event to action mappings entries for first time program unit activation"
	task :populate_events_to_actions_data40 => :environment do
		EventToActionsMapping.create(event_type:736,action_type:6574,method_name:"ProgramUnitEntityService.first_time_pgu_activation_notice_to_self",sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6520,method_name:"ProgramUnitEntityService.first_time_pgu_activation_ebt",sort_order:40,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6517,method_name:"ProgramUnitEntityService.first_time_pgu_activation_ssn_enumeration",sort_order:50,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6518,method_name:"ProgramUnitEntityService.first_time_pgu_activation_citizenship_verification",sort_order:60,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6581,method_name:"ProgramUnitEntityService.first_time_pgu_activation_wage_and_ui",sort_order:70,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6446,method_name:"AlertService.create_alert",sort_order:80,task_type:2172 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6519,method_name:"ProgramUnitEntityService.first_time_pgu_activation_ocse_referral",sort_order:90,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:736,action_type:6582,method_name:"ProgramUnitEntityService.first_time_pgu_member_deactivation",sort_order:100,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end