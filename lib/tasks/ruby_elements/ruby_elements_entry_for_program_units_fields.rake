namespace :ruby_elements_entry_for_program_units_fields  do
	desc "creating ruby lements entry for program units field changes "
	task :create_ruby_elements_for_program_units_fields  => :environment do

        RubyElement.create(element_name:"ProgramUnit",element_title:"eligibility_worker_id", element_type: 6368)
        RubyElement.create(element_name:"ProgramUnit",element_title:"case_manager_id", element_type: 6368)

	end
end