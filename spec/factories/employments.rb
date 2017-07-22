

FactoryGirl.define do 
	factory :employment do |f| 
		f.employer_name "Nike"
		f.effective_begin_date "1900-12-25"
		f.created_by  1
		f.updated_by  1
	end 

	factory :invalid_employment_data, parent: :employment do |f| 
		f.employer_name nil 
		f.effective_begin_date nil
	end 
end 