namespace :update_ruby_elements_title_data_verification do
	desc "update_ruby_elements_title_data_verification"
	task :update_ruby_elements_title_data_verification => :environment do
		RubyElement.where("element_title = 'Data Verification' and element_name like '%program_unit%'").update_all(element_title: 'Check Eligibility')
  end
end