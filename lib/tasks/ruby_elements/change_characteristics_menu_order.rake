namespace :change_characteristics_menu_order do
	desc "This is a template to create menu items"
	task :change_characteristics_menu_order => :environment do



		# 1.General health
		RubyElement.where("id = 12").update_all(element_title:"Characteristics",element_name:'/clients/work/characteristics/index',element_microhelp: 'clients/work')
		RubyElement.where("id = 15").update_all(element_title:"General Health",element_name:'/clients/work/characteristics/index',element_microhelp: 'clients/work')
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 15").update_all(child_order:10)

		# 2.Immunization
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 849").update_all(child_order:20)
		# 3.disability
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 13").update_all(child_order:30)
		# 4.mental
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 847").update_all(child_order:40)
		# 5 substance abuse
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 14").update_all(child_order:50)
		# 6 domestic violence
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 848").update_all(child_order:60)
		# 7 legal
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 727").update_all(child_order:70)
		# 8 pregnancy
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 850").update_all(child_order:80)
		# 9 other
		RubyElementReltn.where("parent_element_id = 12 and child_element_id = 16").update_all(child_order:90)


		# client management/Medical side menu is going away -end



	end
end