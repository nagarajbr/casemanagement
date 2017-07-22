namespace :disable_user_menus do
	desc "This is a template to create menu items"
	task :disable_user_menus => :environment do

		AccessRight.where("ruby_element_id in (193,
												194,
												195,
												196,
												204)
		                 ").update_all(access:'N')
	end
end


