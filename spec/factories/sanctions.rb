
FactoryGirl.define do 
	factory :sanction do |f| 
		f.service_program_id 1
		f.sanction_type 3085
		f.effective_begin_date "2010-01-20"
		duration_type 21
		f.created_by  1
		f.updated_by  1
	end 

	factory :invalid_sanction_data, parent: :sanction do |f| 
		f.service_program_id nil 
		f.effective_begin_date nil
	end 

	
end 