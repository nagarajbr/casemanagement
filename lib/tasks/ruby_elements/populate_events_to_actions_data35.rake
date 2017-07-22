namespace :populate_events_to_actions_data35 do
	desc "event to action mappings entries for absent parent responsibility changes"
	task :populate_events_to_actions_data35 => :environment do
		type = 6368
		ruby_element = RubyElement.create(element_name:"ClientParentalRspability",element_title:"parent_status", element_type: type, description:"Parent Status")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.parental_rspabilities_ocse_referral",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ClientParentalRspability",element_title:"good_cause", element_type: type, description:"Good Cause")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.parental_rspabilities_ocse_referral",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ClientParentalRspability",element_title:"deprivation_code", element_type: type, description:"Deprivation Reason")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.parental_rspabilities_ocse_referral",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ClientParentalRspability",element_title:"court_ordered_amount", element_type: type, description:"Court Order Amount")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.parental_rspabilities_ocse_referral",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ClientParentalRspability",element_title:"amount_collected", element_type: type, description:"Amount Collected")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.parental_rspabilities_ocse_referral",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ClientParentalRspability",element_title:"court_order_number", element_type: type, description:"Court Order Number")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.parental_rspabilities_ocse_referral",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end