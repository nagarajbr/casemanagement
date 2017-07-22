namespace :event_to_action_ruby_element_provider_agreement_update  do
	desc "Update event to action mapping for provider_agreement workflow "
	task :provider_agreement_work_flow_ruby_element_update  => :environment do

		# Request for Approval
	EventToActionsMapping.where("event_type = 6455").update_all("event_type = 690")
	RubyElement.where("id = 690").update_all("description = 'Request for Approval of Provider Agreement' ")

	# Approve
	EventToActionsMapping.where("event_type = 6456").update_all("event_type = 687")
	RubyElement.where("id = 687").update_all("description = 'Request to Approve Provider Agreement is Approved' ")

	# Rejected
	EventToActionsMapping.where("event_type = 6457").update_all("event_type = 691")
	RubyElement.where("id = 691").update_all("description = 'Request to Approve Provider Agreement is Rejected' ")



   end
end