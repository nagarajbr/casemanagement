	namespace :populate_events_to_actions_emp_planning_queue3 do
	desc "populate_events_to_actions_emp_planning_queue3"
	task :populate_events_to_actions_emp_planning_queue3 => :environment do
		#  create Ruby elements.
		ruby_element_object = RubyElement.create(element_name:"ProgramUnit",element_title:"employment_planning_user_id", element_type: 6368)
		# set up event to action data
		EventToActionsMapping.create(event_type:ruby_element_object.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6605 ,enable_flag:'Y',created_by: 1,updated_by: 1)
	end
end