namespace :populate_events_to_actions_data17 do
	desc "update ruby element delete to save and sync with event to action mapping, event type program unit creation"
	task :populate_events_to_actions_data17 => :environment do

		RubyElement.where("id = 243").update_all(element_title:'Save',description:'Program Unit Creation')
		EventToActionsMapping.where("event_type = 6447").update_all("event_type = 243")

	end
end
