namespace :populate_events_to_actions_data79 do
	desc "on reject of benefit amount alert not needed"
	task :populate_events_to_actions_data79 => :environment do
		EventToActionsMapping.where("event_type = 737 and method_name = 'AlertService.create_alert' and task_type = 6612").destroy_all
	end
end

