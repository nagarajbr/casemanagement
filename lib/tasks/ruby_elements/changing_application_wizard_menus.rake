namespace :changing_application_wizard_menus do
    desc "changing_application_wizard_menus"
    task :edit_menus => :environment do
        AccessRight.where("ruby_element_id in (61,62,63)").update_all(access: 'N')
    end
end