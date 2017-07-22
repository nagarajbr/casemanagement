FactoryGirl.define do 
  factory :income_detail_adjust_reason do |f| 
    f.adjusted_amount 138.18
    f.adjusted_reason 4454 #4439
  end

  factory :invalid_income_adjustments_data, parent: :income_detail do |f| 
        f.adjusted_reason nil 
        f.adjusted_amount nil
  end
end 