namespace :update_event_to_action_approve_button_on_provider_invoice  do
	desc "Updating event to action mapping"
	task :update_event_to_action_approve_button_on_provider_invoice  => :environment do
		EventToActionsMapping.where("id = 22").update_all("task_type = 6469")
		EventToActionsMapping.where("id = 23").update_all("task_type = 6469")
		EventToActionsMapping.where("id = 20").update_all("task_type = 6469")
		EventToActionsMapping.where("id = 21").update_all("task_type = 6470")
	end
end