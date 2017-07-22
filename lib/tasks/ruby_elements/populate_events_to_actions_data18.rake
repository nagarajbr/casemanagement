namespace :populate_events_to_actions_data18 do
	desc "update ruby element delete to save and sync with event to action mapping, event type program unit creation"
	task :populate_events_to_actions_data18 => :environment do

		transfer_button_object = RubyElement.create(element_name:"WorkTasksController",element_title:"Transfer", element_type: 6351, description:" Transfer of Case to new local office")

		EventToActionsMapping.where("event_type = 6444").update_all("event_type = #{transfer_button_object.id}")

	end
end
