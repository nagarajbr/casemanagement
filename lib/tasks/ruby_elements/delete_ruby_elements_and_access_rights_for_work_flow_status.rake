namespace :delete_ruby_elements_and_access_rights_for_work_flow do
	desc "delete ruby elements and access rights for work flow"
	task :delete_ruby_entry_for_work_flow_status => :environment do
		# 864 = "work_flow_status"
		RubyElement.where("id = 864").destroy_all
		RubyElementReltn.where("child_element_id = 864 ").destroy_all
		AccessRight.where("ruby_element_id = 864").destroy_all
	end
end