namespace :ruby_elements_access_rights_for_client_application_save  do
	desc "ruby_elements_access_rights_for_client_application_save "
	task :ruby_elements_access_rights_for_client_application_save  => :environment do
                #309 - "Delete" button modified to "Save"
                RubyElement.find(309).update(element_title: "Save")
	end
end