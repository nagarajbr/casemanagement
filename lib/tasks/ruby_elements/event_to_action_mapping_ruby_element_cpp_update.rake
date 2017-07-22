namespace :event_to_action_ruby_element_cpp_update  do
	desc "Update event to action mapping for CPP workflow "
	task :cpp_work_flow_ruby_element_update  => :environment do

		# Request for Approval
	EventToActionsMapping.where("event_type = 6460").update_all("event_type = 291")
	RubyElement.where("id = 291").update_all("description = 'Event Description: Request for Approval of career plan' ")

	# Approve
	EventToActionsMapping.where("event_type = 6461").update_all("event_type = 740")
	RubyElement.where("id = 740").update_all("description = 'Event Description: Request to Approve career plan is Approved' ")

	# Rejected
	EventToActionsMapping.where("event_type = 6462").update_all("event_type = 741")
	RubyElement.where("id = 741").update_all("description = 'Event Description: Request to Approve career plan is Rejected' ")



   end
end