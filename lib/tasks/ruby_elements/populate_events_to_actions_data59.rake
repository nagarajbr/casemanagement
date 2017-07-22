namespace :populate_events_to_actions_data59 do
	desc "event to actions mappings for activity hours"
	task :populate_events_to_actions_data59 => :environment do
		ruby_element = RubyElement.create(element_name:"ActivityHoursController",element_title:"save", element_type: 6351, description:"Save Activity Hours Information")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6610,method_name:"ClientEntityService.work_pays_entry_for_activity_hours_info_change",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end