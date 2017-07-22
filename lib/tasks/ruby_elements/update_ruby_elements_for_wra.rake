namespace :update_ruby_elements_for_wra do
	desc "update ruby elements for work readiness assessment"
	task :update_ruby_elements_for_wra => :environment do

RubyElementReltn.where("child_element_id = 103 and parent_element_id = 82").update_all(child_order: 30)
RubyElementReltn.where("child_element_id = 100 and parent_element_id = 82").update_all(child_order: 40)
RubyElementReltn.where("child_element_id = 107 and parent_element_id = 82").update_all(child_order: 50)
RubyElementReltn.where("child_element_id = 110 and parent_element_id = 82").update_all(child_order: 60)
RubyElementReltn.where("child_element_id = 113 and parent_element_id = 82").update_all(child_order: 70)
RubyElementReltn.where("child_element_id = 116 and parent_element_id = 82").update_all(child_order: 80)
RubyElementReltn.where("child_element_id = 119 and parent_element_id = 82").update_all(child_order: 90)
RubyElementReltn.where("child_element_id = 121 and parent_element_id = 82").update_all(child_order: 100)
RubyElementReltn.where("child_element_id = 128 and parent_element_id = 82").update_all(child_order: 110)
RubyElementReltn.where("child_element_id = 97 and parent_element_id = 82").update_all(child_order: 120)

  end
end


