namespace :disabling_client_management_parental_responsibility_menu do
    desc "disabling_client_management_parental_responsibility_menu"
    task :disabling_client_management_parental_responsibility_menu => :environment do
        AccessRight.where("ruby_element_id in (44,45)").update_all(access: 'N')

        # treating this as update file
        # provider payment management should be visible to all.

        AccessRight.where("ruby_element_id = 154
                           and role_id = 6 ").update_all(access: 'Y')

    end
end