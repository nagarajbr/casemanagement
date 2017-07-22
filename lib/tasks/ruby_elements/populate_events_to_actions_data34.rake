namespace :populate_events_to_actions_data34 do
	desc "event to action mappings entries for resource changes"
	task :populate_events_to_actions_data34 => :environment do
		type = 6368

		# ResourceDetail

		ruby_element = RubyElement.create(element_name:"Resource",element_title:"resource_type", element_type: type, description:"Resource Type")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Resource",element_title:"date_assert_acquired", element_type: type, description:"Date Resource Acquired")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Resource",element_title:"date_assert_disposed", element_type: type, description:"Date Resource Disposed")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:564,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:564,action_type:6525,method_name:"ClientEntityService.resource",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')


		# Resource Detail

		ruby_element = RubyElement.create(element_name:"ResourceDetail",element_title:"resource_valued_date", element_type: type, description:"Resource Valued Date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_detail",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ResourceDetail",element_title:"resource_value", element_type: type, description:"Resource Value")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_detail",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ResourceDetail",element_title:"first_of_month_value", element_type: type, description:"First of month value")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_detail",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:570,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:570,action_type:6525,method_name:"ClientEntityService.resource_detail",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		# Resource Detail Adjustment

		ruby_element = RubyElement.create(element_name:"ResourceAdjustment",element_title:"resource_adj_amt", element_type: type, description:"Resource adjustment amount")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_adjustment",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ResourceAdjustment",element_title:"receipt_date", element_type: type, description:"Adjustment receipt date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_adjustment",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ResourceAdjustment",element_title:"adj_begin_date", element_type: type, description:"Adjustment begin date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_adjustment",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"ResourceAdjustment",element_title:"adj_end_date", element_type: type, description:"Adjustment end date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_adjustment",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:567,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:567,action_type:6525,method_name:"ClientEntityService.resource_adjustment",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		# Resource Usage

		ruby_element = RubyElement.create(element_name:"ResourceUse",element_title:"usage_code", element_type: type, description:"Resource adjustment amount")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.resource_use",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:573,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:573,action_type:6525,method_name:"ClientEntityService.resource_use",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')


	end
end