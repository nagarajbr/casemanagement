namespace :populate_codetable239 do
	desc "instate payments action type dropdown modified"
	task :in_state_payments_action_type => :environment do
		# only active id are shown in the drop down
        CodetableItem.where("id in (6109,6108,6056)").update_all(active:"FALSE")
	end
end