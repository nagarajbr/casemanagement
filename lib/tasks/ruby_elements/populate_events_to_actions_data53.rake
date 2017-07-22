namespace :events_to_actions_mapping53 do
	desc "Events to Actions Mapping for sanctions"
	task :events_to_actions_mapping53 => :environment do
		EventToActionsMapping.create(event_type:595,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:595,action_type:6525,method_name:"ClientEntityService.ed_entry_for_sanctions",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"SanctionDetail",element_title:"release_indicatior", element_type: 6368, description:"Release Indicator")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.ed_entry_for_sanction_detail",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end