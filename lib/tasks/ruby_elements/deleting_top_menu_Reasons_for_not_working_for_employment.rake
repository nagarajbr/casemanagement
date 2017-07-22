namespace :deleting_top_menu_in_employments do
	desc "This is a template to create menu items"
	task :deleting_top_menu_in_employments => :environment do

      connection = ActiveRecord::Base.connection()
      connection.execute("delete from access_rights where ruby_element_id = 90")# 90 is "Reasons Not Working" top menu
      connection.execute("delete from ruby_element_reltns where child_element_id = 90")
      connection.execute("delete from ruby_elements where id = 90")


  end
end
