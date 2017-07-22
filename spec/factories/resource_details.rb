FactoryGirl.define do 
  factory :resource_detail do |f| 
    f.resource_valued_date "2014-08-18" 
    f.resource_value 12345.78
    f.first_of_month_value 0.0
    f.res_ins_face_value 0.0 
    f.amount_owned_on_resource 0.0
    f.amount_owned_as_of_date "2014-08-18"
    f.res_value_basis 2897 #2901            
  end 

  factory :invalid_resource_detail_data, parent: :resource do |f| 
        f.resource_valued_date nil 
        f.resource_value nil
  end 
end 
