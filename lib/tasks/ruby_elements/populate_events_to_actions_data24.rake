namespace :populate_events_to_actions_data24 do
	desc "event to action mappings entries for client characteristics"
	task :populate_events_to_actions_data24 => :environment do
		type = 6368

		ruby_element = RubyElement.create(element_name:"ClientCharacteristic",element_title:"characteristic_id", element_type: type, description:"Client Characteristic characteristic_id")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:6530 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientCharacteristicEntityService.eligibility_determination",sort_order:20,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"ClientCharacteristic",element_title:"start_date", element_type: type, description:"Client Characteristic Start Date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:6530 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientCharacteristicEntityService.eligibility_determination",sort_order:20,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"ClientCharacteristic",element_title:"end_date", element_type: type, description:"Client Characteristic End Date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:6530 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientCharacteristicEntityService.eligibility_determination",sort_order:20,created_by: 1,updated_by: 1)


	end
end