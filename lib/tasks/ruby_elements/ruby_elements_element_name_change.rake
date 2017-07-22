namespace :ruby_elements_element_name_change  do
	desc "element name changed from alien to client"
	task :ruby_elements_element_name_change  => :environment do

        RubyElement.find(816).update(element_name: "Client")
    end
end