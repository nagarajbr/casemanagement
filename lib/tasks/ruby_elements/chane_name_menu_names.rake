namespace :change_menu_names do
	desc "This is a template to create menu items"
	task :change_menu_names => :environment do
		RubyElement.where("id in (136)
		                 ").update_all(element_title:"Tasks")

		RubyElement.where("id in (138)
		                 ").update_all(element_title:"Applications/Cases")

		RubyElement.where("id in (819)
		                 ").update_all(element_title:"Queues")
        RubyElementReltn.where("parent_element_id = 135
								and child_element_id = 811
								").update_all(child_order:90)

		RubyElementReltn.where("parent_element_id = 135
								and child_element_id = 819
								").update_all(child_order:80)
	end
end

