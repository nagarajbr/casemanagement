namespace :update_event_to_action  do
	desc "Updating event to action mapping"
	task :update_event_to_action  => :environment do
		EventToActionsMapping.where("id = 206").destroy_all
		EventToActionsMapping.where("id = 208").destroy_all
	end
end