

FactoryGirl.define do 
	factory :pregnancy do |f| 
		f.pregnancy_due_date "2014-10-28"
		f.number_of_unborn 1
		f.created_by  1
		f.updated_by  1
	end 

	factory :invalid_pregnancy_data, parent: :pregnancy do |f| 
		f.pregnancy_due_date nil 
		f.number_of_unborn nil
	end 
end 