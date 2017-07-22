namespace :events_to_actions_mapping7 do
	desc "Events to Actions Mapping Data7"
	task :events_to_actions_mapping7 => :environment do
		# Request for Approval of Provider Invoice
		EventToActionsMapping.create(event_type:6493,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6491 ,created_by: 1,updated_by: 1)
		# Request to Approve Provider Invoice is Rejected
		# complete task = 6491
		# create work task = 6492 (work on rejected Provider Invoice)
		EventToActionsMapping.create(event_type:6495,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6491 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6495,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6492 ,created_by: 1,updated_by: 1)

		# Request to Approve Provider Invoice is Approved
		# complete task = 6491
		# create alert = 6491 (Request for Approval of Provider Invoice - Approved.)
		EventToActionsMapping.create(event_type:6494,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6491 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6494,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:6491 ,created_by: 1,updated_by: 1)
	end
end