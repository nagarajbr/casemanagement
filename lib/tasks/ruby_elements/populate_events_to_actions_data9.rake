namespace :events_to_actions_mapping9 do
	desc "Events to Actions Mapping Data9"
	task :events_to_actions_mapping9 => :environment do
		# Request for Approval of Program Unit
		EventToActionsMapping.create(event_type:6496,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:2172 ,created_by: 1,updated_by: 1)
		# Request to Approve Program Unit is Rejected
		# complete task = 2172
		# create work task = 6388 (work on rejected Program Unit)
		EventToActionsMapping.create(event_type:6498,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:2172 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6498,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:20,task_type:6388 ,created_by: 1,updated_by: 1)

		# Request to Approve Program Unit is Approved
		# complete task = 2172
		# create alert = 2172 (Request for Approval of Program Unit - Approved.)
		EventToActionsMapping.create(event_type:6497,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:2172 ,created_by: 1,updated_by: 1)
		EventToActionsMapping.create(event_type:6497,action_type:6446,method_name:"AlertService.create_alert",sort_order:20,task_type:2172 ,created_by: 1,updated_by: 1)
	end
end