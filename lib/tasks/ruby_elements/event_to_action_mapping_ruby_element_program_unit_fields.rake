namespace :event_to_action_ruby_element_program_unit_fields  do
	desc "Update event to action mapping for CPP workflow "
	task :create_event_to_action_entries_program_unit_fields  => :environment do

		EventToActionsMapping.where("event_type = 6501").update_all("event_type = 747")
		RubyElement.where("id = 747").update_all("description = 'Complete Case Manager Assignment'")

		EventToActionsMapping.where("event_type = 6502").update_all("event_type = 746")
		RubyElement.where("id = 746").update_all("description = 'Complete Eligibility Worker Assignment'")

   end
end