namespace :populate_events_to_actions_data39 do
	desc "event to action mappings entries for program unit closure"
	task :populate_events_to_actions_data39 => :environment do
		EventToActionsMapping.create(event_type:810,action_type:6519,method_name:"ProgramUnitEntityService.ocse_closure_referral",sort_order:40,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end