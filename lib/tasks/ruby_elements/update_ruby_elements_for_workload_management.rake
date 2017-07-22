namespace :update_ruby_elements_for_workload_management do
	desc "update ruby elements for workload management"
	task :update_ruby_elements_for_workload_management => :environment do



        RubyElement.find(135).update(element_name: "/alerts")
		RubyElementReltn.where("child_element_id = 721 and parent_element_id = 135").update_all(child_order: 70)



		end
	end




