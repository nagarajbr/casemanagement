namespace :update_ruby_elements_for_menu_name_changes do
	desc "update ruby elements for provider enrollment managment to Educational Institution Management"
	task :update_ruby_elements_for_menu_name_changes => :environment do
	  RubyElement.find(182).update(element_title: "Educational Institution Management")
	end
end