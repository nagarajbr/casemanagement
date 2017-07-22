namespace :populate_events_to_actions_data25 do
	desc "event to action mappings entries for client immunization"
	task :populate_events_to_actions_data25 => :environment do

		ruby_element = RubyElement.create(element_name:"/potential_intake_clients",element_title:"Intake Queues", element_type: 6350,element_microhelp: "potential_intake_clients",element_help_page: "AS")
        ruby_element.destroy
		type = 6368

		ruby_element = RubyElement.create(element_name:"Client",element_title:"exempt_from_immunization", element_type: type, description:"Client exempt from immunization")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.immunization",sort_order:20,created_by: 1,updated_by: 1)

		ruby_element = RubyElement.create(element_name:"ClientImmunization",element_title:"immunizations_record", element_type: type, description:"Client Immunizations immunizations_record")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6525,method_name:"ClientEntityService.immunization",sort_order:20,created_by: 1,updated_by: 1)


	end
end