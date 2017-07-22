namespace :update_provider_event_to_action_mapping1 do
	desc "event to action mapping for save button"
	task :event_to_action_mapping_for_provider_save_button  => :environment do
		EventToActionsMapping.where("id = 276 and event_type = 537").update_all(method_name: 'QueueService.delete_queue', action_type: 6630, queue_type: 6639)
		EventToActionsMapping.create(event_type: 537,action_type:6458,method_name:"WorkTaskService.complete_work_task",task_type: 6641,sort_order:20,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end
