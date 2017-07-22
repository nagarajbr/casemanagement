namespace :removing_transportation_challenge_menu do
	desc "removing transportation challange menu "
	task :removing_transportation_challenge_menu => :environment do

      RubyElement.find(104).update(element_title: 'Transportation Challenge')
      connection = ActiveRecord::Base.connection()
      connection.execute("delete from access_rights where ruby_element_id = 106")# 106 is "Transportation Challenge" top menu
      connection.execute("delete from ruby_element_reltns where child_element_id = 106")
      connection.execute("delete from ruby_elements where id = 106")




	end
end
