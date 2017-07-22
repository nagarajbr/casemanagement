namespace :events_to_actions_mapping8 do
	desc "Events to Actions Mapping Data8"
	task :events_to_actions_mapping8 => :environment do
		# Service Payment Approved
		EventToActionsMapping.create(event_type:6467,action_type:6445,method_name:"WorkTaskService.create_work_task",sort_order:10,task_type:6491 ,created_by: 1,updated_by: 1)
	end
end