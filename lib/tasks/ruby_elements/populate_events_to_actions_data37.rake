namespace :populate_events_to_actions_data37 do
	desc "event to action mappings entries for program unit closure"
	task :populate_events_to_actions_data37 => :environment do
		ruby_element = RubyElement.create(element_name:"ProgramUnitActionsController",element_title:"save", element_type: 6351)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6575,method_name:"ProgramUnitEntityService.program_unit_closure",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6576 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6574,method_name:"ProgramUnitEntityService.notice_on_program_unit_closure",sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end