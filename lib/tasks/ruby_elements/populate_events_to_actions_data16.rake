namespace :populate_events_to_actions_data16  do
	desc "Update event to action mapping for Ready for Assessment"
	task :populate_events_to_actions_data16  => :environment do

		EventToActionsMapping.where("event_type = 6499").update_all("event_type = 684")
		RubyElement.where("id = 684").update_all("description = 'Ready for Assessment - this event will close ED task and create task to assign case manager'")

   end
end