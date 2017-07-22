namespace :update_event_to_action_citizenship_disable_flag  do
	desc "Updating event to action mapping disable flag "
	task :update_event_to_action_citizenship_disable_flag  => :environment do
		EventToActionsMapping.where("id = 202").update_all("enable_flag = 'N'")
	end
end