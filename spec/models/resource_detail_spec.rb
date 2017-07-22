require 'rails_helper'

RSpec.describe ResourceDetail, :type => :model do

	setup :activate_authlogic

	before :each do
		fake_login()
    	create_resource()
    end

    def fake_login
		 @user = FactoryGirl.create(:user)
	     @user_session = FactoryGirl.create(:user_session)
	     AuditModule.set_current_user=(@user)	     
	end	

    def create_resource
		@resource = FactoryGirl.create(:resource, date_assert_acquired: "2014-08-01", date_assert_disposed: "2014-08-31")
	end	

	it "has a valid factory" do
		FactoryGirl.create(:resource_detail, resource: @resource).should be_valid
	end

	it "is invalid without resource_valued_date" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_valued_date: nil).should_not be_valid
	end

	it "is invalid with resource_valued_date before resource begin date" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_valued_date: "2014-07-01").should_not be_valid
	end

	it "is invalid with resource_valued_date after resource end date" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_valued_date: "2014-10-01").should_not be_valid
	end

	it "should be valid with resource_valued_date between resource begin date and end date" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_valued_date: "2014-08-01").should be_valid
	end

	it "should be valid with resource_valued_dateu same as resource begin date" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_valued_date: "2014-08-01").should be_valid
	end

	it "should be valid with resource_valued_dateu same as resource end date" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_valued_date: "2014-08-31").should be_valid
	end

	it "should be valid with resource_value 6 digits max and 2 decimal places max" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_value: 123456.12).should be_valid
	end

	it "should be invalid with resource_value more than 6 digits max" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_value: 1234567.12).should_not be_valid
	end

	it "should be invalid with resource_value greater than 2 decimal places max" do
		FactoryGirl.build(:resource_detail, resource: @resource, resource_value: 12345678.123).should_not be_valid
	end

	it "deletes associated resources details when resource is deleted" do
		FactoryGirl.create(:resource_detail, resource: @resource, resource_valued_date: "2014-08-31")
		expect { 
		  @resource.destroy
		}.to change(ResourceDetail, :count).by(-1)
	end 
end