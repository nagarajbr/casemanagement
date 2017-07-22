namespace :populate_events_to_actions_data44 do
	desc "event to actions mappings entries for cancelling a payment line item"
	task :populate_events_to_actions_data44 => :environment do
		ruby_element = RubyElement.create(element_name:"InStatePaymentsController",element_title:"Save", element_type: 6351, description:"Save")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6519,method_name:"ClientEntityService.ocse_referral_on_cancel_pymt",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6520,method_name:"ClientEntityService.ebt_on_cancel_pymt",sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end