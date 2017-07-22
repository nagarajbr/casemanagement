namespace :populate_events_to_actions_application_queue2 do
	desc "populate_events_to_actions_application_queue2"
	task :populate_events_to_actions_application_queue2 => :environment do
		EventToActionsMapping.where("event_type = 747
									and task_type = 6344
									").destroy_all
	end
end