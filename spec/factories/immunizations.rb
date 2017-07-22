
FactoryGirl.define do 
	factory :immunization do |f| 
		# f.date_administered "2010-10-28"
		#  first vaccination type record = "Polio - 1st"
		f.vaccine_type 2
		f.created_by  1
		f.updated_by  1
	end 

	factory :invalid_immunization_data, parent: :immunization do |f| 
		f.date_administered "1888-10-28" 
		f.vaccine_type nil
	end 

	# factory :immunizations, class:Array do
	# 	# f.date_administered "2010-10-28"
	# 	#  first vaccination type record = "Polio - 1st"
	# 	vaccine_type 2
	# 	created_by  1
	# 	updated_by  1

	# 	initialize_with { [ attributes[:vaccine_type,:created_by,:updated_by] ,attributes] }
	# end 

	factory :immunizations, class:Array do
	end
	
end 