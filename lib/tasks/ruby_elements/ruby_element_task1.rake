namespace :event_to_action_mapping_ruby_elements1 do
	desc "Events to Actions Mapping Data14"
	task :event_to_action_mapping_ruby_elements1 => :environment do
		# 738 "Close"
        # 739 "Extend"

		EventToActionsMapping.create(event_type:738,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:2140 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
		EventToActionsMapping.create(event_type:739,action_type:6458,method_name:"WorkTaskService.complete_work_task",sort_order:10,task_type:2140 ,created_by: 1,updated_by: 1,enable_flag: 'Y')
	end
end
