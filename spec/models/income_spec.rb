require 'rails_helper'

RSpec.describe "Income" do

  setup :activate_authlogic

  before :each do
    fake_login()
  end

  def fake_login
      #simulating user login, setting up logged in user
      @user = FactoryGirl.create(:user)
      #setting up logged in user information in a thread in order to make it available across models.
      AuditModule.set_current_user=(@user)      
  end

  it "has a valid factory" do
  	FactoryGirl.create(:income).should be_valid
  end

  it "is invalid without incometype" do
  	FactoryGirl.build(:income, incometype: nil).should_not be_valid
  end

  it "should be valid with incometype" do
  	FactoryGirl.build(:income, incometype: 2658).should be_valid
  end

  it "is invalid without frequency" do
  	FactoryGirl.build(:income, frequency: nil).should_not be_valid
  end

  it "should be valid with frequency" do
  	FactoryGirl.build(:income, frequency: 2862).should be_valid
  end

  it "is invalid without effective_beg_date" do
  	FactoryGirl.build(:income, effective_beg_date: nil).should_not be_valid
  end

  it "should be valid with effective_beg_date" do
  	FactoryGirl.build(:income, effective_beg_date: "2014-04-19").should be_valid
  end  

  # it "has many clients" do
  #   income = FactoryGirl.create(:income)
  #   client1 = Client.create(client_attributes)
  #   client2 = FactoryGirl.create(:client, first_name: "kiran", last_name: "chamarthi")
  #   client1.client_incomes.create!(income: income, created_by: 1, updated_by: 1)
  #   client2.client_incomes.create!(income: income, created_by: 1, updated_by: 1)
  #   expect(income.client_incomes).to include(client1)
  #   expect(income.client_incomes).to include(client2)
  # end

  it "deletes associated income details" do
    #income = Income.create!(income_attributes)
    income = FactoryGirl.create(:income)
    income.income_details.create!(income_detail_attributes)
    expect { 
      income.destroy
    }.to change(IncomeDetail, :count).by(-1)
  end

  it "should be valid with amount value 6 digits max and 2 decimal places max" do
  	FactoryGirl.build(:income, amount: 123456.12).should be_valid
  end

  it "should be invalid with amount more than 6 digits max" do
  	FactoryGirl.build(:income, amount: 1234567.12).should_not be_valid
  end

  it "should be invalid with amount greater than 2 decimal places max" do
  	FactoryGirl.build(:income, amount: 12345678.123).should_not be_valid
  end

  it "should be valid with contract amount less than 6 digits" do
  	FactoryGirl.build(:income, contract_amt: 999999.99).should be_valid
  end

  it "should be invalid with contract amount more than 6 digits" do
  	FactoryGirl.build(:income, contract_amt: "1234567.1").should_not be_valid
  end

  it "should be invalid with contract amount more than 2 decimals" do
  	FactoryGirl.build(:income, contract_amt: 1234.123).should_not be_valid
  end

  it "should have valid begin_date_less_than_end_date" do 
  	income = FactoryGirl.create(:income)
  	income.begin_date_less_than_end_date?.should == true
  end 

end
