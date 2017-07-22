# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :time_limit do |f|
  	    f.payment_date "2010/01/01".to_date
		f.work_participation_reason 3085
		f.state 4668
		f.created_by  1
		f.updated_by  1
  end
end
