require 'rails_helper'
#require 'spec_helper'

#describe Expense do
RSpec.describe Expense do
  #pending "add some examples to (or delete) #{__FILE__}"
 
  it "is invalid without an expensetype"  do
  	FactoryGirl.build(:expense, expensetype: nil).should_not be_valid
  end
  it "is invalid without a frequency" do
  	FactoryGirl.build(:expense, frequency: nil).should_not be_valid
  end
  it "is invalid without an effective_beg_date" do
  	FactoryGirl.build(:expense, effective_beg_date: nil).should_not be_valid
  end
  it "is valid without an effective_end_date" do
  	FactoryGirl.build(:expense, effective_end_date: nil).should be_valid
  end

  #Test cases to verify amount field
  it "is invalid if amount in greater than 8 digits before decimal" do
    FactoryGirl.build(:expense, amount: "123456789").should_not be_valid
  end
  it "is invalid if amount in greater than 8 digits before decimal and greater than 2 digits after decimal" do
    FactoryGirl.build(:expense, amount: "123456789.123").should_not be_valid
  end
  it "is invalid if amount in greater than 8 digits before decimal and less than 2 digits after decimal" do
    FactoryGirl.build(:expense, amount: "123456789.1").should_not be_valid
  end
  it "is invalid if amount in greater than 8 digits before decimal and equal than 2 digits after decimal" do
    FactoryGirl.build(:expense, amount: "123456789.12").should_not be_valid
  end
  it "is valid if amount in less than 8 digits before decimal and equal than 2 digits after decimal" do
    FactoryGirl.build(:expense, amount: "1234567.12").should be_valid
  end
  it "is valid if amount is equal to 8 digits before decimal and equal than 2 digits after decimal" do
    FactoryGirl.build(:expense, amount: "12345678.12").should be_valid
  end
  it "is invalid if amount is equal to 8 digits before decimal and greater than 2 digits after decimal" do
    FactoryGirl.build(:expense, amount: "12345678.123").should_not be_valid
  end
  # it "is invalid if amount accepts any alphabets" do
  #   FactoryGirl.build(:expense, amount: "12345h.1h").should_not be_valid
  # end


  #Test cases to verify creditor name field
  it "is invalid if creditor name is greater than 35 characters" do
    FactoryGirl.build(:expense, creditor_name: "abcdefghijklmnopqrstuvwxyzabcdefghij").should_not be_valid
  end
  it "is valid if creditor name is less than 35 characters" do
    FactoryGirl.build(:expense, creditor_name: "abcdefghijklmnopqrstuvwxyzabcdefgh").should be_valid
  end
  it "is valid if creditor name is equal to 35 characters" do
    FactoryGirl.build(:expense, creditor_name: "abcdefghijklmnopqrstuvwxyzabcdefghi").should be_valid
  end

  #Test cases to verify creditor contact field
  it "is invalid if creditor contact is greater than 35 characters" do
    FactoryGirl.build(:expense, creditor_contact: "abcdefghijklmnopqrstuvwxyzabcdefghij").should_not be_valid
  end
  it "is valid if creditor contact is less than 35 characters" do
    FactoryGirl.build(:expense, creditor_contact: "abcdefghijklmnopqrstuvwxyzabcdefgh").should be_valid
  end
  it "is valid if creditor contact is equal to 35 characters" do
    FactoryGirl.build(:expense, creditor_contact: "abcdefghijklmnopqrstuvwxyzabcdefghi").should be_valid
  end
  it "is valid if creditor contact can accept numbers and special characters" do
    FactoryGirl.build(:expense, creditor_contact: "abcdefghijklmnopq#-,123_/.").should be_valid
  end


  #Test cases to verify creditor phone number field
  it "is invalid if creditor phone accepts alphabets and special characters" do
    FactoryGirl.build(:expense, creditor_phone: "abcd123#").should_not be_valid
  end
  it "is invalid if creditor phone is less than 10 digits" do
    FactoryGirl.build(:expense, creditor_phone: "012345678").should_not be_valid
  end
  it "is invalid if creditor phone is greater than 10 digits" do
    FactoryGirl.build(:expense, creditor_phone: "01234567890").should_not be_valid
  end
  it "is valid if creditor phone is equal to 10 digits" do
    FactoryGirl.build(:expense, creditor_phone: "0123456789").should be_valid
  end
  it "is valid if creditor phone is nil" do
    FactoryGirl.build(:expense, creditor_phone: nil).should be_valid
  end


  #Test cases to verify creditor phone extension field
  it "is invalid if creditor extension accepts alphabets and special characters" do
    FactoryGirl.build(:expense, creditor_ext: "12#.").should_not be_valid
  end
  it "is invalid if creditor extension greater than 5 digits" do
    FactoryGirl.build(:expense, creditor_ext: "123456").should_not be_valid
  end
  it "is valid if creditor extension equals to 5 digits" do
    FactoryGirl.build(:expense, creditor_ext: "12345").should be_valid
  end
  it "is valid if creditor extension less than 5 digits" do
    FactoryGirl.build(:expense, creditor_ext: "1234").should be_valid
  end
  it "is valid if creditor extension is nil" do
    FactoryGirl.build(:expense, creditor_ext: nil).should be_valid
  end


  it "effective_end_date lesser than effective_beg_date" do
  	expensedate_validation = FactoryGirl.build(:expense, effective_beg_date: "2014-07-30", effective_end_date: "2014-07-29" )  	
  	expensedate_validation.effective_end_date_be_greater_than_effective_beg_date.should == false
  end
  it "effective_end_date greater than effective_beg_date" do
  	expensedate_validation = FactoryGirl.build(:expense, effective_beg_date: "2014-07-29", effective_end_date: "2014-07-30" )  	
  	expensedate_validation.effective_end_date_be_greater_than_effective_beg_date.should == true
  end
  it "effective_end_date equal to effective_beg_date" do
  	expensedate_validation = FactoryGirl.build(:expense, effective_beg_date: "2014-07-29", effective_end_date: "2014-07-29" )  	
  	expensedate_validation.effective_end_date_be_greater_than_effective_beg_date.should == true
  end
  it "effective_end_date is null" do
  	expensedate_validation = FactoryGirl.build(:expense, effective_beg_date: "2014-07-29", effective_end_date: nil )  	
  	expensedate_validation.effective_end_date_be_greater_than_effective_beg_date.should == true
  end
end
