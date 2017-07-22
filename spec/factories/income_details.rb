FactoryGirl.define do 
  factory :income_detail do |f| 
    f.check_type 4385     
    f.date_received "2014-07-31" 
    f.gross_amt 0.0  
    f.cnt_for_convert_ind 1
    f.created_by 1
    f.updated_by 1
  end 

  factory :invalid_income_detail_data, parent: :income do |f| 
        f.check_type nil 
        f.date_received nil
  end 
end 
