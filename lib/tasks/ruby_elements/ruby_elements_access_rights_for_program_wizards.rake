namespace :ruby_elements_access_rights_for_program_wizards  do
	desc "program_wizards ruby elemts and access rights "
	task :program_wizards_ruby_element_access_rights  => :environment do



        #684 - "Mark Active" button modified to "Ready for Assessment"
        RubyElement.find(684).update(element_title: "Ready for Assessment")
        AccessRight.find(3699).update(access: "N")
        AccessRight.find(1963).update(access: "Y")
        AccessRight.create(role_id:6, ruby_element_id: 684,access:'Y', created_at: Time.now, updated_at: Time.now)


        #534 - Delete button modified to "Continue Assessment"
        RubyElement.find(534).update(element_title: "Continue Assessment")
        AccessRight.find(3693).update(access: "N")
        AccessRight.find(1957).update(access: "Y")
        AccessRight.create(role_id:6, ruby_element_id: 534 ,access:'Y', created_at: Time.now, updated_at: Time.now)

        #682 "Complete Program Unit" button modified to Request for Approval of Benefit Amount
        RubyElement.find(682).update(element_title: "Request for Approval of Benefit Amount")
        AccessRight.find(3697).update(access: "N")
        AccessRight.find(1961).update(access: "Y")
        AccessRight.create(role_id:6, ruby_element_id: 682 ,access:'Y', created_at: Time.now, updated_at: Time.now)



	end
end