namespace :update_event_to_action_tea_diversion do
	desc "event to actions mappings for alien"
	task :update_event_to_action_tea_diversion => :environment do
		EventToActionsMapping.where("id = 281 and event_type = 737").update_all("queue_type = 6558")
		# when rejected TEA diversion is submitted again - work task to approve the PGU should be sent to supervisor
		EventToActionsMapping.create(event_type:684,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:30,task_type:2172 ,enable_flag: 'Y', created_by: '555',updated_by: '555')
		EventToActionsMapping.create(event_type:684,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:40,task_type:6388 ,enable_flag: 'Y',created_by: '555',updated_by: '555')

		# additional rake tasks .
		# Provider submit payment - should move it to queue and any pending rejected tasks should be completed.
		# work on approval task is disabled here it will be handled from common queue assignment code
		EventToActionsMapping.where("id = 14 and event_type = 618 and task_type = 6469").update_all("enable_flag = 'N'")

		# additional rake tasks
		# when submit button is clicked - if there is determine ED task pending it should be completed.
		# this is for change in composition scenario.
		EventToActionsMapping.where("id = 325 and event_type = 683 and task_type = 6386").update_all("task_type = 6346")
	end
end
