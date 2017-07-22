namespace :update_event_to_action_sanctions_disable_flag  do
	desc "Updating event to action mapping disable flag "
	task :update_event_to_action_sanctions_disable_flag  => :environment do
		EventToActionsMapping.where("id = 242 and event_type = 595 and action_type = 6446").update_all("enable_flag = 'N'")
		EventToActionsMapping.where("id = 243 and event_type = 595 and action_type = 6525").update_all("enable_flag = 'N'")
	end
end