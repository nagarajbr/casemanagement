namespace :ruby_elements_element_name_change_for_app_processing_menu  do
	desc "app processing menu url change"
	task :ruby_elements_element_name_change_for_app_processing_menu  => :environment do
        # RubyElement.find(816).update(element_name: "Client")
        RubyElement.where("id in (862,863)").update_all(element_name: "/applications")
    end
end