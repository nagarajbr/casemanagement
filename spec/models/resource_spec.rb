require 'rails_helper'

RSpec.describe "Resource" do

  setup :activate_authlogic
  
  before :each do
    fake_login()
  end

  def fake_login
   @user = FactoryGirl.create(:user)
     @user_session = FactoryGirl.create(:user_session)
     AuditModule.set_current_user=(@user)      
  end 

  it "has a valid factory" do
  	FactoryGirl.create(:resource).should be_valid
  end

  it "is invalid without resource type" do
  	FactoryGirl.build(:resource, resource_type: nil).should_not be_valid
  end

  it "should be valid with incometype" do
  	FactoryGirl.build(:resource, resource_type: 2435).should be_valid
  end

  it "should be valid with net_value 6 digits max and 2 decimal places max" do
  	FactoryGirl.build(:resource, net_value: 123456.12).should be_valid
  end

  it "should be invalid with net_value more than 6 digits max" do
  	FactoryGirl.build(:resource, net_value: 1234567.12).should_not be_valid
  end

  it "should be invalid with net_value greater than 2 decimal places max" do
  	FactoryGirl.build(:resource, net_value: 12345678.123).should_not be_valid
  end

  it "should be valid with usage percent less than 3 digits and 1 decimal" do
  	FactoryGirl.build(:resource, use_code: 999.9).should be_valid
  end

  it "should be invalid with usage percent more than 3 digits" do
  	FactoryGirl.build(:resource, use_code: "1234.").should_not be_valid
  end

  it "should be invalid with usage percent more than 1 decimals" do
  	FactoryGirl.build(:resource, use_code: 123.99).should_not be_valid
  end

  it "should have valid begin_date_less_than_end_date" do 
  	resource = FactoryGirl.create(:resource)
  	resource.begin_date_less_than_end_date?.should == true
  end 

  it "should be invalid if begin_date greater than end date" do 
  	FactoryGirl.build(:resource, date_assert_acquired: "2014-08-11",date_assert_disposed: "2014-07-31").should_not be_valid
  end

  it "deletes associated client resources" do
    client = FactoryGirl.create(:client)
    resource = FactoryGirl.create(:resource)
    client.client_resources.create(resource: resource, created_by: 1, updated_by: 1)
    expect { 
      resource.destroy
    }.to change(ClientResource, :count).by(-1)
  end 

end
