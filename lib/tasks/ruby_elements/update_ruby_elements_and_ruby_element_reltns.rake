namespace :update_ruby_element_and_relation_for_user_location do
	desc "User location is moved from utilities management to workload management "
	task :update_ruby_element_and_relation_for_user_location => :environment do

		RubyElement.where("id in (190)").update_all(element_name:"/system_param_categories")
		RubyElementReltn.where("parent_element_id = 190 and child_element_id = 191").update_all(parent_element_id:135 , child_order:110)

	end
end