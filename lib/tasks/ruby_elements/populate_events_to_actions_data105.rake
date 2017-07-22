namespace :populate_events_to_actions_data105 do
	desc "event to action mappings close activities associated to program unit on closure"
	task :populate_events_to_actions_data105 => :environment do
		EventToActionsMapping.create(event_type:810,action_type:6759,method_name:"ProgramUnitEntityService.close_all_program_unit_representatives",sort_order:60,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end