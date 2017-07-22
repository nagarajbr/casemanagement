namespace :populate_events_to_actions_data104 do
	desc "event to actions mappings for navigator screen apply button"
	task :populate_events_to_actions_data104 => :environment do
		ruby_element = RubyElement.create(element_name:"NavigatorController",element_title:"Apply Button", element_type: 6351, description:"create eligible program units")
		#319;866;6458;"WorkTaskService.complete_work_task";30;2155;"1";"1";"2016-02-02 22:07:53.83473";"2016-02-02 22:07:53.83473";"Y";
		EventToActionsMapping.where("event_type = 866 and task_type = 2155").update_all(event_type: ruby_element.id, sort_order: 10)
		EventToActionsMapping.create(event_type: ruby_element.id,action_type: 6586,method_name: "QueueService.create_queue",sort_order: 20,queue_type: 6558 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.where("event_type = 746 and action_type = 6445").update_all(event_type: ruby_element.id, sort_order: 30)
		EventToActionsMapping.where("event_type = 243 and task_type = 6736").update_all(task_type: 6593, enable_flag: 'Y')
	end
end
