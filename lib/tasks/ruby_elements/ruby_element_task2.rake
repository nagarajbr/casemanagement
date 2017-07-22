namespace :disable_hh_member_characteristics_menu_ruby_elements2 do
	desc "disable hh member characteristics menu"
	task :disable_hh_member_characteristics_menu_ruby_elements2 => :environment do
	   AccessRight.where("ruby_element_id = 845").update_all(access: 'N')
    end
end