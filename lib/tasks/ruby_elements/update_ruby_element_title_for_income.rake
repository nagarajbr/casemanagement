namespace :update_ruby_element_title_for_income do
	desc "update ruby element title from benefits received to income"
	task :update_ruby_element_title_for_income => :environment do



        RubyElement.find(99).update(element_title: "Income")

    end
end
