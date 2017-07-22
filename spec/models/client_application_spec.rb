require 'rails_helper'

# rspec spec/models/client_application_spec.rb -fd
RSpec.describe ClientApplication, :type => :model do
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
  #1.
	it "has a valid factory" do 
		FactoryGirl.create(:client_application, application_date: "2010-12-25",service_program_group: 6015).should be_valid
	end

	
	#2.
	it "is invalid without a Application Date"  do
		FactoryGirl.build(:client_application, application_date: nil).should_not be_valid 
	end

	#3.
	it "is valid with a Application Date"  do
		FactoryGirl.build(:client_application,application_date: "2010-12-25").should be_valid 
	end

	#4.
	it "is invalid without a Service Program Group"  do
		FactoryGirl.build(:client_application, application_date: nil).should_not be_valid 
	end

	#5.
	it "is valid with a Service Program Group"  do
		FactoryGirl.build(:client_application,service_program_group: 6015).should be_valid 
	end

	#6.
	it "is invalid with application date less than 1900" do
		FactoryGirl.build(:client_application, application_date: "1889-01-01").should_not be_valid 
	end

	#7.
	it "is valid with application date greater than 1900 and Less than Today" do
		FactoryGirl.build(:client_application, application_date: "2014-01-01").should be_valid 
	end

	#6.
	it "is invalid with application date greater than Today" do
		FactoryGirl.build(:client_application, application_date: "1.day.since(Time.now.to_date)").should_not be_valid 
	end
	
end
