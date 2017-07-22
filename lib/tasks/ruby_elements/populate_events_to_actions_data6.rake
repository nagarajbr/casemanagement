namespace :events_to_actions_mapping6 do
	desc "Events to Actions Mapping Data6"
	task :events_to_actions_mapping6 => :environment do
		# Request for Approval of Service Payment
		EventToActionsMapping.create(event_type:6466,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6469 ,created_by: 1,updated_by: 1)
		# Request to Approve Service Payment is Rejected
		# complete task = 6469
		# create work task = 6464 (work on rejected Service Payment)
		EventToActionsMapping.create(event_type:6468,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6469 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6468,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6470 ,created_by: 1,updated_by: 1)

		# Request to Approve Service Payment is Approved
		# complete task = 6469
		# create alert = 6469 (Request for Approval of Service Payment - Approved.)
		EventToActionsMapping.create(event_type:6467,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:6469 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6467,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:6469 ,created_by: 1,updated_by: 1)
	end
end