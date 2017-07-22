namespace :events_to_actions_mapping5 do
	desc "Events to Actions Mapping Data5"
	task :events_to_actions_mapping5 => :environment do
		# Request for Approval of CPP
		EventToActionsMapping.create(event_type:6460,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6463 ,created_by: 1,updated_by: 1)
		# Request for Approval of CPP - rejected.
		# complete task = 6463
		# create work task = 6464 (work on rejected CPP)
		EventToActionsMapping.create(event_type:6462,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6463 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6462,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6464 ,created_by: 1,updated_by: 1)

		# Request for Approval of CPP - Approved.
		# complete task = 6463
		# create alert = 6463 (Request for Approval of CPP - Approved.)
		EventToActionsMapping.create(event_type:6461,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6463 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6461,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:6463 ,created_by: 1,updated_by: 1)
	end
end