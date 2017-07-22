namespace :populate_events_to_actions_data27 do
	desc "event to action mappings entries for out of state payments"
	task :populate_events_to_actions_data27 => :environment do

		ruby_element = RubyElement.create(element_name:"OutOfStatePaymentsController",element_title:"Save", element_type: 6351, description:"Create Out of State Payments")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.out_of_state_payments",sort_order:20,created_by: 1,updated_by: 1)

		# ruby_element = RubyElement.create(element_name:"OutOfStatePaymentsController",element_title:"Delete", element_type: 6351, description:"Delete Out of State Payments")
		EventToActionsMapping.create(event_type:468,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)

	end
end