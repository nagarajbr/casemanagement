require 'faker'

FactoryGirl.define do 
	factory :expense do |f| 
		f.expensetype 2533
		f.frequency { Faker::Number.digit }
		f.effective_beg_date "2014-07-30"
		f.created_by 1
		f.updated_by 1
	end 

	factory :invalid_expense, parent: :expense do |f| 
		f.expensetype nil
		f.frequency nil
		f.effective_beg_date nil
		
	end 
	
end 
