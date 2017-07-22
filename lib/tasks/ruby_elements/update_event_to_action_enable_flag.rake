namespace :update_event_to_action_enable_flag  do
	desc "Updating event to action mapping enable flag "
	task :update_event_to_action_enable_flag  => :environment do


	EventToActionsMapping.update_all("enable_flag = 'Y'")


   end
end