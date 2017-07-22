FactoryGirl.define do 
  factory :resource do |f| 
    f.resource_type 2449 #2435
    f.account_number 111111111111
    f.description "Test Data Object from Factory Class"
    f.date_assert_acquired "2014-07-30"
    f.date_assert_disposed "2014-07-31"
    f.number_of_owners 18
    f.net_value 138.18
    f.date_value_determined "2014-07-30"
    f.use_code 18.0
    f.verified 1
    f.year "1998"
    f.make "Toyota"
    f.model "Corolla"
    f.license_number 1234567891   
  end 
  factory :invalid_resource_data, parent: :client do |f| 
    f.resource_type nil         
  end
end 
