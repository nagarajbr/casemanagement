namespace :update_housing_menu_for_assessments do
	desc "housing"
	task :update_housing_menu_for_assessments => :environment do


      connection = ActiveRecord::Base.connection()
      connection.execute("delete from access_rights where ruby_element_id = 102")# 102 is "Housing Situation" top menu
      connection.execute("delete from ruby_element_reltns where child_element_id = 102")
      connection.execute("delete from ruby_elements where id = 102")

       RubyElement.find(101).update(element_title: "Housing Situation")

	end
end


