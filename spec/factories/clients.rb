
require 'faker'

FactoryGirl.define do 

	factory :client do |f| 
		f.first_name "John"#{ Faker::Name.first_name } 
		f.last_name  "Doe"#{ Faker::Name.last_name } 
		f.ssn "999999999"
		f.created_by  1
		f.updated_by  1
	end 

	factory :invalid_client_data, parent: :client do |f| 
		f.firstname nil 
		f.ssn nil
	end
	
end 