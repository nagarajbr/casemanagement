

FactoryGirl.define do 
	factory :address do |f| 
		f.address_type 4664
		f.address_line1 "1501 Chenal Parkway"
		f.city "Little Rock"
		f.state 4667
		f.zip 72223
		f.created_by  1
		f.updated_by  1
	end 
end 