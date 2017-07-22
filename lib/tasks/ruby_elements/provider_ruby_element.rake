namespace :provider_ruby_element  do
	desc "create ruby elements and access rights"
	task :create_complete_registration_button  => :environment do

    	RubyElement.create(element_name:"ProvidersController",element_title:"Complete Registration", element_type: 6351) #6351 button

	end
end