namespace :populate_events_to_actions_data51 do
	desc "event to actions mappings entries for provider information "
	task :populate_events_to_actions_data51 => :environment do
		ruby_element = RubyElement.create(element_name:"Provider",element_title:"status", element_type: 6368, description:"Save")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Provider",element_title:"provider_name", element_type: 6368, description:"Save")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Provider",element_title:"tax_id_ssn", element_type: 6368, description:"Save")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		ruby_element = RubyElement.create(element_name:"Provider",element_title:"classification", element_type: 6368, description:"Save")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:762,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:763,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:764,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:765,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')

		EventToActionsMapping.create(event_type:766,action_type:6591,method_name:"ProviderEntityService.aasis_verification",sort_order:10,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end