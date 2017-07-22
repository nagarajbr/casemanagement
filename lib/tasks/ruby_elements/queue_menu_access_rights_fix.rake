namespace :queue_menu_access_rights_fix do
	desc "queue_menu_access_rights_fix"
	task :queue_menu_access_rights_fix => :environment do
		AccessRight.where("ruby_element_id = 812 and role_id in (2,5) ").update_all(access: 'N')
		AccessRight.where("ruby_element_id = 811 and role_id in (2,5) ").update_all(access: 'N')
	end
end

