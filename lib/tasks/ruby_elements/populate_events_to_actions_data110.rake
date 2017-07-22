namespace :populate_events_to_actions_data110 do
	desc "event to action mappings entries for program unit closure"
	task :populate_events_to_actions_data110 => :environment do
		EventToActionsMapping.create(event_type:810, action_type:6773, method_name:"ProgramUnitEntityService.delete_pgu_pending_tasks", sort_order:15, created_by: 555, updated_by: 555, enable_flag: 'Y')
		EventToActionsMapping.create(event_type:810,action_type:6519,method_name:"ProgramUnitEntityService.ocse_closure_referral",sort_order:70,created_by: 555,updated_by: 555,enable_flag: 'Y')
	end
end