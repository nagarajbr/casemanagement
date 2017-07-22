namespace :populate_events_to_actions_data26 do
	desc "event to action mappings entries for client pregnancy"
	task :populate_events_to_actions_data26 => :environment do

		type = 6368

		ruby_element = RubyElement.create(element_name:"Pregnancy",element_title:"pregnancy_due_date", element_type: type, description:"Pregnancy due date")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)


		ruby_element = RubyElement.create(element_name:"Pregnancy",element_title:"number_of_unborn", element_type: type, description:"Expected Number of Children")
		EventToActionsMapping.create(event_type:ruby_element.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:10,task_type:2173 ,created_by: 1,updated_by: 1)



	end
end