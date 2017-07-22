namespace :populate_events_to_actions_data38 do
	desc "event to action mappings entries for Citizenship information changed"
	task :populate_events_to_actions_data38 => :environment do
		EventToActionsMapping.create(event_type:757,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:757,action_type:6518,method_name:"ClientEntityService.citizenship_verification_for_citizenship_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:757,action_type:6518,method_name:"ClientEntityService.ed_entry_for_citizenship_info_change",sort_order:30,created_by: 1,updated_by: 1,enable_flag: 'Y')

		type = 6368
		ruby_element = RubyElement.create(element_name:"Alien",element_title:"refugee_status", element_type: type, description:"Immigration Status")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.ed_entry_for_non_citizenship_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Alien",element_title:"alien_DOE", element_type: type, description:"Alien Date of Entry")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.ed_entry_for_non_citizenship_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end