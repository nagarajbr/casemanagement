namespace :populate_events_to_actions_data30 do
	desc "event to action mappings entries for income_details changes"
	task :populate_events_to_actions_data30 => :environment do
		type = 6368
		ruby_element = RubyElement.create(element_name:"IncomeDetail",element_title:"check_type", element_type: type, description:"check_type")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income_details",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"IncomeDetail",element_title:"date_received", element_type: type, description:"Date Received")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income_details",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"IncomeDetail",element_title:"gross_amt", element_type: type, description:"Gross Amount")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income_details",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"IncomeDetail",element_title:"cnt_for_convert_ind", element_type: type, description:"Count for converted")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.income_details",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:438,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:438,action_type:6525,method_name:"ClientEntityService.income_details",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end