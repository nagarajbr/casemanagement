namespace :update_menu_name_to_work_characteristics do
	desc "This is a template to upate menu items"
	task :update_menu_name_to_work_characteristics => :environment do
		RubyElement.where("id in (15,108)
		                 ").update_all(element_title:"Work/Deferred/Exempt Characteristics")
	end
end