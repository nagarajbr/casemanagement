namespace :update_events_to_actions_for_release_3_1 do
	desc "update_events_to_actions_for_release_3_1"
	task :update_events_to_actions_for_release_3_1 => :environment do
		# for release 3.1 submit button after PGU activation should not do any queue movement
	  EventToActionsMapping.where("event_type = 683 and queue_type = 6559").update_all("enable_flag = 'N'")
	end
end