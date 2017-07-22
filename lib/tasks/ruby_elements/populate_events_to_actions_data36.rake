namespace :populate_events_to_actions_data36 do
	desc "event to action mappings entries for program unit submit"
	task :populate_events_to_actions_data36 => :environment do
		EventToActionsMapping.create(event_type:683,action_type:6574,method_name:"ProgramUnitEntityService.program_unit_submit",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end