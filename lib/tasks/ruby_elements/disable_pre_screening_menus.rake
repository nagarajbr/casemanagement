namespace :disable_prescreening_menus do
	desc "This is a template to create menu items"
	task :disable_prescreening_menus => :environment do

		AccessRight.where("ruby_element_id in (1,2,3,139)
		                 ").update_all(access:'N')

		RubyElement.where("id in (138)
		                 ").update_all(element_title:"My Application/Cases")

		RubyElement.where("id in (138)
		                 ").update_all(element_name:"/my_applications")
	end
end

