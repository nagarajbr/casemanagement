namespace :populate_events_to_actions_data80 do
	desc "moving_work_load_management_menu_below_prescreening"
	task :populate_events_to_actions_data80 => :environment do
		RubyElement.where("id = 135").update_all(parent_order:15)
	end
end