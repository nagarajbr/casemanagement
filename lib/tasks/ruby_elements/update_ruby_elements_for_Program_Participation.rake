namespace :update_ruby_elements_for_Program_Participation do
	desc "update ruby elements for Program Participation - Timelimits,Out of state payments,Payment History"
	task :update_ruby_elements_for_Program_Participation => :environment do



        RubyElement.find(41).update(element_title: "TEPC") #"Time Limits"
        RubyElement.find(42).update(element_title: "Out of State Participation") #"Out of state payments"
        RubyElement.find(43).update(element_title: "Cash Benefits")#"Payment History"




		end
	end


