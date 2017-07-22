FactoryGirl.define do 
	factory :employment_detail do |f| 
		f.effective_begin_date "1900-12-25"
		f.hours_per_period 160
		f.salary_pay_amt 1000.00
		f.position_type 2296
		f.current_status 2332
		f.salary_pay_frequency 2317
		f.created_by  1
		f.updated_by  1
	end 

	factory :invalid_employment_detail_data, parent: :employment_detail do |f| 
		f.effective_begin_date nil
		f.hours_per_period nil
		f.salary_pay_amt nil
		f.salary_pay_frequency nil
		f.current_status nil
		f.created_by  1
		f.updated_by  1
	end 
end 