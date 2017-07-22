	namespace :events_to_actions_queue_update4 do
	desc "events_to_actions_queue_update4"
	task :events_to_actions_queue_update4 => :environment do
		# EventToActionsMapping.create(event_type:ruby_element_object.id,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6605 ,enable_flag:'Y',created_by: 1,updated_by: 1)
		EventToActionsMapping.where("element_name = 'ApplicationScreeningsController' and element_title = 'Save' and element_type = 6351").update_all(element_title: 'Complete Application' )
	end
end

