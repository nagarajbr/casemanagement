namespace :populate_events_to_actions_data19 do
	desc "reassign program unit to a different case manage within same local office"
	task :populate_events_to_actions_data19 => :environment do
		reaasign_button_object = RubyElement.create(element_name:"WorkTasksController",element_title:"Reassign", element_type: 6351, description:"Request to change case manager id,reassign to same local office")
		EventToActionsMapping.create(event_type:reaasign_button_object.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2178 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:reaasign_button_object.id,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:2178 ,created_by: 1,updated_by: 1)
	end
end
