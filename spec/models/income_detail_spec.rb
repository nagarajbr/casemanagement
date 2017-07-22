require 'rails_helper'

# RSpec.describe ExpenseDetail, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

RSpec.describe IncomeDetail do

  before :each do
    @income = FactoryGirl.create(:income)
  end

	it "has a valid factory" do
  		#FactoryGirl.create(:income_detail).should be_valid
      # income = FactoryGirl.create(:income) 
      # income.income_details.create!(income_detail_attributes).should be_valid
      @income.income_details.create!(income_detail_attributes).should be_valid     
  end

	it "is invalid without date received" do
  		#FactoryGirl.build(:income_detail, date_received: nil).should_not be_valid
      @income.income_details.build(income_detail_attributes(date_received: nil)).should_not be_valid
  end

  it "is invalid without check type" do
      #FactoryGirl.build(:income_detail, check_type: nil).should_not be_valid
      @income.income_details.build(income_detail_attributes(check_type: nil)).should_not be_valid
  end

  it "should be valid with gross amount less than equal 6 digits" do
    @income.income_details.build(income_detail_attributes(gross_amt: 123456)).should be_valid
  end

  it "should be invalid with gross amount more than 6 digits" do
    @income.income_details.build(income_detail_attributes(gross_amt: 123456789.1)).should_not be_valid
  end

  it "should be valid with gross amount less than equal 2 decimals" do
    @income.income_details.build(income_detail_attributes(gross_amt: 123456.18)).should be_valid
  end

  it "should be invalid with gross amount more than 2 decimals" do
    @income.income_details.build(income_detail_attributes(gross_amt: 1234.123)).should_not be_valid
  end
	
	it "should have valid date received" do 
    income_detail = @income.income_details.create(income_detail_attributes(date_received: "2014/07/31"))
    income_detail.date_received_valid?.should == true
  end

  it "should be invalid if date received is not within income effective begin and end dates " do 
    income_detail = @income.income_details.create(income_detail_attributes(date_received: "2014/08/11"))
    income_detail.date_received_valid?.should_not == true
  end

  it "should be valid if date received is greater income effective begin date and no end date" do 
    income_detail = FactoryGirl.create(:income, effective_end_date: nil).income_details.create(income_detail_attributes(date_received: "2014/07/31"))
    income_detail.date_received_valid?.should == true
  end

  it "should be valid if date received is equal to income effective begin date and no end date" do 
    income_detail = FactoryGirl.create(:income, effective_end_date: nil).income_details.create(income_detail_attributes(date_received: "2014/07/31"))
    income_detail.date_received_valid?.should == true
  end

  it "should not be valid if date received less than income effective begin date and no end date" do 
    income_detail = FactoryGirl.create(:income, effective_end_date: nil).income_details.create(income_detail_attributes(date_received: "2014/07/29"))
    income_detail.date_received_valid?.should_not == true
  end

  it "should be valid if date received is equal to income effective begin date and no end date" do 
    income_detail = FactoryGirl.create(:income, effective_end_date: nil).income_details.create(income_detail_attributes(date_received: "2014/07/31"))
    income_detail.date_received_valid?.should == true
  end

end