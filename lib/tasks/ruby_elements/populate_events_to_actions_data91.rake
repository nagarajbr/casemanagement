namespace :populate_events_to_actions_data91 do
	desc "event to action mappings close activities associated to program unit on closure"
	task :populate_events_to_actions_data91 => :environment do
		EventToActionsMapping.create(event_type:810,action_type:6575,method_name:"ProgramUnitEntityService.close_all_associated_activities_on_program_unit_closure",sort_order:40,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:810,action_type:6630,method_name:"QueueService.delete_queue",sort_order:50,created_by: 1,updated_by: 1,enable_flag: 'Y',queue_type: 6616)
	end
end