namespace :change_health_char_menu_to_substance_abuse_menu do
	desc "This is a template to create menu items"
	task :change_health_char_menu_to_substance_abuse_menu => :environment do



		RubyElement.where("id = 14").update_all(element_title:"Substance Abuse",element_name:'/clients/substance_abuse/characteristics/index',element_microhelp: 'substance_abuse')
		# change work characteristics menu to general health menu
		RubyElement.where("id = 15").update_all(element_title:"General Health")

		# client management/Medical side menu is going away -start
		AccessRight.where("ruby_element_id in (17,18,19,20)
		                 ").update_all(access:'N')



		# client management/Medical side menu is going away -end



	end
end