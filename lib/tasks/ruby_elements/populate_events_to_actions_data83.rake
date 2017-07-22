namespace :populate_events_to_actions_data83 do
	desc "event to action mappings Approve cpp"
	task :populate_events_to_actions_data83 => :environment do


		EventToActionsMapping.where("event_type = 740 and method_name = 'WorkTaskService.create_work_task' and task_type = 6633").destroy_all
		EventToActionsMapping.where("event_type = 740 and method_name = 'QueueService.create_queue' and queue_type = 6626").destroy_all
		EventToActionsMapping.where("event_type = 740 and method_name = 'QueueService.create_queue' and queue_type = 6625").update_all(queue_type:6562)
		# complte assessment will not create task
		EventToActionsMapping.where("event_type = 662 and method_name = 'WorkTaskService.create_work_task' and task_type = 6633").destroy_all

		# cpp approval reject will move queue back to "Ready for Employment Readiness planning"
		EventToActionsMapping.where("event_type = 741 and method_name = 'QueueService.delete_queue' and queue_type = 6561").update_all(method_name:'QueueService.create_queue',queue_type:6560)

	end
end


