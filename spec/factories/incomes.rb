FactoryGirl.define do 
  factory :income do |f| 
    f.incometype 2658 
    f.source "C:"
    f.verified "1"
    f.frequency 2862 
    f.effective_beg_date "2014-07-30"
    f.effective_end_date "2014-07-31"
    f.intended_use_mos "12"
    f.contract_amt "120.00"
    f.inc_avg_beg_date "2014-07-30"
    f.notes "test data"
    f.recal_ind "1"    
  end 

  factory :invalid_income_data, parent: :income do |f| 
        f.incometype nil 
        f.frequency nil
  end 
end 
