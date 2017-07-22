namespace :update_event_to_action_citizenship_disable_flag_1  do
	desc "Updating event to action mapping disable flag "
	task :update_event_to_action_citizenship_disable_flag_1  => :environment do
		EventToActionsMapping.where("id = 204").update_all("enable_flag = 'N'")
	end
end