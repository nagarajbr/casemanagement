namespace :events_to_actions_mapping65 do
	desc "Events to Actions Mapping for approve or reject career plan"
	task :events_to_actions_mapping65 => :environment do
		EventToActionsMapping.where("task_type = 6463").update_all(task_type:6607)
		EventToActionsMapping.where("event_type = 740 and task_type = 6607 and sort_order in (30,40)").destroy_all
	end
end