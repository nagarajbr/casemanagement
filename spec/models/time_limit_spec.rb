require 'rails_helper'
include AuditModule

# rspec spec/models/time_limit_spec.rb -fd
RSpec.describe TimeLimit, :type => :model do
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
		cl =FactoryGirl.create(:client)
		FactoryGirl.create(:time_limit, client: cl,created_by:1,updated_by:1).should be_valid
    end

    # 2.
	it "is invalid without payment_date"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, payment_date: nil).should_not be_valid 
	end

	#3.
	it "is valid with payment_date populated" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, payment_date: "2012-12-20").should be_valid 
	end 

	# 4.
	it "is invalid with payment_date less than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, payment_date: "1889-01-01").should_not be_valid 
	end

	#5.
	it "is valid with payment_date greater than 1900" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, payment_date: "2014-01-01").should be_valid 
	end

	it "is invalid with payment_date greater than Today" do
		# femaile = 4478
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client_id: client.id, payment_date: "#{1.day.since(Time.now.to_date)}").should_not be_valid 
	end

	#6.
	it "is valid with payment_date equal Today" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, payment_date: "#{Time.now.to_date}").should be_valid 
	end

	#7.
	it "is valid with payment_date less than Today" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, payment_date: "#{(-1).day.since(Time.now.to_date)}").should be_valid 
	end

	# 8.
	it "is invalid without a work_participation_reason"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, work_participation_reason: nil).should_not be_valid 
	end

	# 9.
	it "is valid with a work_participation_reason"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, work_participation_reason: 1).should be_valid 
	end

	# 10.
	it "is invalid without a payment state"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, state: nil).should_not be_valid 
	end

	# 11.
	it "is valid with a a payment state"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:time_limit, client: client, state: 1).should be_valid 
	end
 	
 	# 12.
 	it "is invalid with  same (client_id,state,payment_month,payment_type)record"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.create(:time_limit, client: client, state: 1,payment_date:"2012-02-01",payment_type: 1)
		FactoryGirl.build(:time_limit, client: client, state: 1,payment_date:"2012-02-01",payment_type: 1).should_not be_valid 
	end
 	
 	# 12.
 	it "is valid with  different (client_id,state,payment_month,payment_type)record"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.create(:time_limit, client: client, state: 1,payment_date:"2012-02-01",payment_type: 1)
		FactoryGirl.build(:time_limit, client: client, state: 1,payment_date:"2012-03-01",payment_type: 1).should be_valid 
	end



end
