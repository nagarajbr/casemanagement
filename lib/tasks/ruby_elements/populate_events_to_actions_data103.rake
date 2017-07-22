namespace :populate_events_to_actions_data103  do
	desc "creating ruby elements and events for client application application processor field changes"
	task :populate_events_to_actions_data103  => :environment do
        ruby_element = RubyElement.create(element_name:"ClientApplication",element_title:"application_processor", element_type: 6368)
        EventToActionsMapping.create(event_type:ruby_element.id, action_type:6445, method_name:"WorkTaskService.create_work_task", sort_order:10, task_type:2155, created_by: 1, updated_by: 1, enable_flag: 'Y')
        EventToActionsMapping.create(event_type:866,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:30,task_type:2155,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end