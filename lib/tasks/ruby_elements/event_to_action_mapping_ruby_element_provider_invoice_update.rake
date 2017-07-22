namespace :event_to_action_ruby_element_provider_invoice_update  do
	desc "Update event to action mapping for provider_invoice workflow "
	task :provider_invoice_work_flow_ruby_element_update  => :environment do

		# Request for Approval
	EventToActionsMapping.where("event_type = 6493").update_all("event_type = 745")
	RubyElement.where("id = 745").update_all("description = 'Request for Approval of Provider Invoice' ")

	# Approve
	EventToActionsMapping.where("event_type = 6494").update_all("event_type = 692")
	RubyElement.where("id = 692").update_all("description = 'Request to Approve Provider Invoice is Approved' ")

	# Rejected
	EventToActionsMapping.where("event_type = 6495").update_all("event_type = 549")
	RubyElement.where("id = 549").update_all("description = 'Request to Approve Provider Invoice is Rejected' ")



   end
end