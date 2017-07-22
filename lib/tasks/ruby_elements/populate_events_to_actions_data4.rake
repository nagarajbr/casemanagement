namespace :events_to_actions_mapping4 do
	desc "Events to Actions Mapping Data4"
	task :events_to_actions_mapping4 => :environment do
		# Request for Approval of provider Agreement
		EventToActionsMapping.create(event_type:6455,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6353 ,created_by: 1,updated_by: 1)
		# Request for Approval of provider Agreement - rejected.
		# complete task = 6353
		# create work task = 6459 (work on rejected provider agreement)
		EventToActionsMapping.create(event_type:6457,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6353 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6457,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6459 ,created_by: 1,updated_by: 1)

		# Request for Approval of provider Agreement - Approved.
		# complete task = 6353
		# create alert = 6353 (Request for Approval of provider Agreement - Approved.)
		EventToActionsMapping.create(event_type:6456,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6353 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6456,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:6353 ,created_by: 1,updated_by: 1)
	end
end