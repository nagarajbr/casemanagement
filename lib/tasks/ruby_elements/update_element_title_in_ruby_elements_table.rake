namespace :update_element_title_of_service_authorization_table do
	desc "update request for approval button to submit payment"
	task :update_button_to_submit_payment  => :environment do
		RubyElement.where("id = 618").update_all(element_title: 'Submit Payment')
	end
end