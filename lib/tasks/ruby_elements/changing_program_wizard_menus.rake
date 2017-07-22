namespace :changing_program_wizard_menus do
    desc "changing_program_wizard_menus.rake"
    task :edit_menus => :environment do
        AccessRight.where("ruby_element_id in (67,69,70)").update_all(access: 'N')
        RubyElement.where("id = 71").update_all(element_title: "Eligibility Determination") # prev value "Check Eligibility"
        # editing program unit menu, # inorder to revert update the record 66 with 67 information
        RubyElement.where("id = 66").update_all(element_name: "/program_unit/program_unit_data_validation_index/session[:PROGRAM_UNIT_ID]/program_unit_data_validation_results",element_title: "Data Verification",element_microhelp: "program_unit/program_unit_data_validation_index") # prev value "Validate Program Unit"
    end
end