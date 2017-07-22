namespace :changing_eligibility_determinations_menu do
    desc "changing_eligibility_determinations_menu.rake"
    task :edit_menu_title => :environment do
        RubyElement.where("id in (71,72)").update_all(element_title: "Eligibility Determinations") # prev value "Eligibility Determination"
    end
end