namespace :ruby_element_reltns_and_access_rights_for_work_load_management  do
	desc "work load management changes on menu, ruby element relations and access rights  "
	task :ruby_element_reltns_and_access_rights_for_work_load_management  => :environment do


       RubyElementReltn.where("parent_element_id= 717 and child_element_id=718").update_all(parent_element_id:138 , child_order:40)
       RubyElementReltn.where("parent_element_id= 719 and child_element_id=720").update_all(parent_element_id:138 , child_order:30)
       AccessRight.where("ruby_element_id in(138,139) ").update_all(access:'Y')
       AccessRight.where("ruby_element_id in(717,719) ").update_all(access:'N')
       AccessRight.where("ruby_element_id = 109").destroy_all

	end
end