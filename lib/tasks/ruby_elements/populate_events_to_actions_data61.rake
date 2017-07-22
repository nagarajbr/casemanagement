namespace :events_to_actions_mapping61 do
	desc "Events to Actions Mapping for sanction details"
	task :events_to_actions_mapping61 => :environment do
		ruby_element = RubyElement.create(element_name:"SanctionDetailsController",element_title:"Save", element_type: 6351, description:"Add Sanction Detail")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.ed_entry_for_sanction_detail",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end