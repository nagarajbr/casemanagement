namespace :populate_events_to_actions_data28 do
	desc "event to action mappings entries for income changes"
	task :populate_events_to_actions_data28 => :environment do
		type = 6368
		ruby_element = RubyElement.create(element_name:"Income",element_title:"incometype", element_type: type, description:"Income type")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Income",element_title:"frequency", element_type: type, description:"Frequency")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Income",element_title:"effective_beg_date", element_type: type, description:"Begin Date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Income",element_title:"effective_end_date", element_type: type, description:"End Date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Income",element_title:"recal_ind", element_type: type, description:"Recalculate Indicator")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:435,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:435,action_type:6525,method_name:"ClientEntityService.income",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end