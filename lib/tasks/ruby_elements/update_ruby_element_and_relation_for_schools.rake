namespace :update_ruby_element_and_relation_for_schools do
	desc "User location is moved from utilities management to workload management "
	task :update_ruby_element_and_relation_for_schools => :environment do

		RubyElement.where("id in (184,182,183)").update_all(element_name:"/searchschools/search")
	end
end