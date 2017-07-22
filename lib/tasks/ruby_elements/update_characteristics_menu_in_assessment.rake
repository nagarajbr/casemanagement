namespace :update_characteristics_menu_in_assessment do
    desc "This is a template to create menu items"
    task :update_characteristics_menu_in_assessment => :environment do



        # 1.General health
        RubyElement.where("id = 107").update_all(element_title:"General Health",element_name:'/ASSESSMENT/work/characteristics/index',element_microhelp: 'ASSESSMENT/work')
        RubyElement.where("id = 108").update_all(element_title:"General Health",element_name:'/ASSESSMENT/work/characteristics/index',element_microhelp: 'ASSESSMENT/work')

        # 2. Immunization - normal client management - added parameter menu CLIENT
        RubyElement.where("id = 849").update_all(element_title:"Immunization",element_name:'/CLIENT/client_immunization/show',element_microhelp: 'CLIENT/client_immunization')
        RubyElement.where("id = 20").destroy_all

        # 3
        # 1.Mental health
        RubyElement.where("id = 110").update_all(element_name:'/ASSESSMENT/mental/characteristics/index',element_microhelp: 'ASSESSMENT/mental')
        RubyElement.where("id = 111").update_all(element_name:'/ASSESSMENT/mental/characteristics/index',element_microhelp: 'ASSESSMENT/mental')

        # client management menu passing client parameter.
        RubyElement.where("id = 847").update_all(element_microhelp: 'clients/mental')

        # 4.
        # substance abuse
        RubyElement.where("id = 113").update_all(element_name:'/ASSESSMENT/substance_abuse/characteristics/index',element_microhelp: 'ASSESSMENT/substance_abuse')
        RubyElement.where("id = 114").update_all(element_name:'/ASSESSMENT/substance_abuse/characteristics/index',element_microhelp: 'ASSESSMENT/substance_abuse',element_title:'Substance Abuse')
        # setting correct menu help so client menu is selected
        RubyElement.where("id = 14").update_all(element_microhelp: 'clients/substance_abuse')
        # household drugs going aways
        AccessRight.where("ruby_element_id in (115)").update_all(access:'N')

        # 5.
        # Domestic Violence
        RubyElement.where("id = 116").update_all(element_name:'/ASSESSMENT/domestic/characteristics/index',element_microhelp: 'ASSESSMENT/domestic')
        RubyElement.where("id = 117").update_all(element_name:'/ASSESSMENT/domestic/characteristics/index',element_microhelp: 'ASSESSMENT/domestic')
         # setting correct menu help so client menu is selected
        RubyElement.where("id = 848").update_all(element_microhelp: 'clients/domestic')

        # perpetrator going aways
        AccessRight.where("ruby_element_id in (118)").update_all(access:'N')


        # 6.
        # pregnancy
        RubyElement.where("id = 119").update_all(element_name:'/ASSESSMENT/clients/medical_pregnancy/show',element_microhelp: 'ASSESSMENT/clients/medical_pregnancy')
        RubyElement.where("id = 120").update_all(element_name:'/ASSESSMENT/clients/medical_pregnancy/show',element_microhelp: 'ASSESSMENT/clients/medical_pregnancy')
          # setting correct menu help so client menu is selected
        RubyElement.where("id = 850").update_all(element_microhelp: 'CLIENT/clients/medical_pregnancy',element_name:'/CLIENT/clients/medical_pregnancy/show')

        # 7. Mental health diagnosis going aways
        # client management/Medical side menu is going away -start
        AccessRight.where("ruby_element_id in (112)").update_all(access:'N')

        # 8. assessment disability /client disability menu highlight fix
          # setting correct menu help so client menu is selected
        RubyElement.where("id = 13").update_all(element_microhelp: 'clients/disability')


         # work interest going away
        AccessRight.where("ruby_element_id in (95)").update_all(access:'N')


        # Currently working assessment sections question deletion .
        AssessmentQuestion.where("assessment_sub_section_id = 2
                                  and id in (5,592,593,910,908,885,911,909,888)
                                  ").destroy_all











    end
end

