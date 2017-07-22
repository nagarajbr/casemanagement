namespace :add_intake_management_registration_menu do
	desc "This is a template to create menu items"
	task :add_intake_management_registration_menu => :environment do

			# level_1_menu
			level_1_menu = RubyElement.find(840)
			level_1_menu.element_name = '/hh_registration_wizard/index'
			level_1_menu.save

			level_2_menu = RubyElement.find(841)
			level_2_menu.element_name = '/hh_registration_wizard/index'
			level_2_menu.save

			level_3_menu = RubyElement.find(842)
			level_3_menu.element_name = '/hh_registration_wizard/index'
			level_3_menu.element_title = 'Household Registration'
			level_3_menu.element_microhelp = 'hh_registration_wizard'
			level_3_menu.save


			ruby_element_reltns_collection  = RubyElementReltn.where("parent_element_id = 841 and child_element_id in (843,844,845)")
			if ruby_element_reltns_collection.present?
				ruby_element_reltns_collection.destroy_all
			end


	end
end