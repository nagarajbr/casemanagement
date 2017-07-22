namespace :populate_events_to_actions_data41 do
	desc "event to action mappings entries for Residency information changed"
	task :populate_events_to_actions_data41 => :environment do
		type = 6368
		ruby_element = RubyElement.create(element_name:"Alien",element_title:"residency", element_type: type, description:"Residency")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.ed_entry_for_residency_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end