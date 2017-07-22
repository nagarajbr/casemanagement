namespace :populate_events_to_actions_data47 do
	desc "event to actions mappings entries for adding / deactivating program unit representative"
	task :populate_events_to_actions_data47 => :environment do
		ruby_element = RubyElement.create(element_name:"ProgramUnitRepresentativesController",element_title:"Save", element_type: 6351, description:"Save")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6520,method_name:"ClientEntityService.ebt_on_adding_a_representative",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:678,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:678,action_type:6520,method_name:"ClientEntityService.ebt_on_deactivating_a_representative",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end