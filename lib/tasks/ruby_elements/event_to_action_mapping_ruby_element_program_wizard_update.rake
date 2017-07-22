namespace :event_to_action_ruby_element_program_wizard_update  do
	desc "Update event to action mapping for program_wizard workflow "
	task :program_wizard_work_flow_ruby_element_update  => :environment do

		# Request for Approval
	EventToActionsMapping.where("event_type = 6496").update_all("event_type = 682")
	RubyElement.where("id = 682").update_all("description = 'Request for Approval First Time Benefit Amount' ")

	# Approve
	EventToActionsMapping.where("event_type = 6497").update_all("event_type = 736")
	RubyElement.where("id = 736").update_all("description = 'Request to Approve First Time Benefit Amount is Approved' ")

	# Rejected
	EventToActionsMapping.where("event_type = 6498").update_all("event_type = 737")
	RubyElement.where("id = 737").update_all("description = 'Request to Approve First Time Benefit Amount is Rejected' ")



   end
end