namespace :disabling_menus_realtionship_status_finance_and_final_thoughts do
    desc "removing menus realtionship status, finance and final thoughts"
    task :disable_menus => :environment do
        AccessRight.where("ruby_element_id in (97,128,130)").update_all(access: 'N')
        RubyElementReltn.where("parent_element_id = 82 and child_element_id = 88").update_all(child_order: 135)
    end
end