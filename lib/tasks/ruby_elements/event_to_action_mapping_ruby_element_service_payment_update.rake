namespace :event_to_action_ruby_element_service_payment_update  do
	desc "Update event to action mapping for service_payment workflow "
	task :service_payment_work_flow_ruby_element_update  => :environment do

		# Request for Approval
	EventToActionsMapping.where("event_type = 6466").update_all("event_type = 618")
	RubyElement.where("id = 618").update_all("description = 'Request for Approval of Service Payment' ")

	# Approve
	EventToActionsMapping.where("event_type = 6467").update_all("event_type = 729")
	RubyElement.where("id = 729").update_all("description = 'Request to Approve Service Payment is Approved' ")

	# Rejected
	EventToActionsMapping.where("event_type = 6468").update_all("event_type = 742")
	RubyElement.where("id = 742").update_all("description = 'Request to Approve Service Payment is Rejected' ")



   end
end