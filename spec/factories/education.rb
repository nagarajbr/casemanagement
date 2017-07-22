

FactoryGirl.define do 
	factory :education do |f| 
		f.school_type "2194"
		f.high_grade_level "09"
		f.created_by 1
		f.updated_by 1
	end 	

	factory :invalid_education, parent: :education do |f|
		f.school_type nil 
		f.high_grade_level nil
	end 
end 