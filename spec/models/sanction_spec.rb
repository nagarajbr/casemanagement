require 'rails_helper'

# rspec spec/models/sanction_spec.rb -fd
RSpec.describe Sanction, :type => :model do

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
		l_client =FactoryGirl.create(:client)
		FactoryGirl.create(:sanction, client_id: l_client.id).should be_valid
    end

    #2.
	it "is invalid without a service_program_id"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, service_program_id: nil).should_not be_valid 
	end

	# #3.
	it "is Valid with a service_program_id"  do
		client = FactoryGirl.create(:client) 
		# service program ID = 1 = TEA.
		FactoryGirl.build(:sanction, client_id: client.id, service_program_id: 1).should be_valid 
	end

	# 4.
	it "is invalid without a sanction_type"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, sanction_type: nil).should_not be_valid 
	end

	# 5.
	# 3083 = "QA Non Cooperation"
	it "is Valid with a sanction_type"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, sanction_type: 3083).should be_valid 
	end

	# 6.
	it "is invalid without a effective_begin_date"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, effective_begin_date: nil).should_not be_valid 
	end

	# 7.
	
	it "is Valid with a effective_begin_date"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, effective_begin_date: "2012-01-25").should be_valid 
	end

	# 8.
	it "is invalid without a duration_type"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, duration_type: nil).should_not be_valid 
	end

	# 9.
	
	it "is Valid with a duration_type"  do
		client = FactoryGirl.create(:client) 
		# 22 = 1 week
		FactoryGirl.build(:sanction, client_id: client.id, duration_type: 22).should be_valid 
	end

	
	# 10.
	it "is invalid with effective_begin_date less than 1900/01/01" do
		# femaile = 4478
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, effective_begin_date: "1889-01-01").should_not be_valid 
	end

	#11.
	it "is valid with effective_begin_date greater than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client: client, effective_begin_date: "2014-01-01").should be_valid 
	end

	# 12.
	it "is invalid with effective_begin_date greater than Today" do
		# femaile = 4478
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client_id: client.id, effective_begin_date: "#{1.day.since(Time.now.to_date)}").should_not be_valid 
	end

	#13.
	it "is valid with effective_begin_date equal Today" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client: client, effective_begin_date: "#{Time.now.to_date}").should be_valid 
	end

	#13.
	it "is valid with effective_begin_date less than Today" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client: client, effective_begin_date: "#{(-1).day.since(Time.now.to_date)}").should be_valid 
	end


	#14.
	it "is valid with null infraction_date " do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client: client, infraction_date: nil).should be_valid 
	end


	#15.
	it "is invalid with infraction_date less than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client: client, infraction_date: "1889-01-01").should_not be_valid 
	end

	#15.
	it "is Valid with infraction_date greater than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:sanction, client: client, infraction_date: "2010-01-01").should be_valid 
	end

	#16.
	it "is Invalid if you create sanction record with same (client ID, Service Program ID, Sanction Type and Effective Begin Date)." do
		client = FactoryGirl.create(:client) 
		FactoryGirl.create(:sanction, client: client, service_program_id: 1,sanction_type: 3059,effective_begin_date: "2010-01-20")
		FactoryGirl.build(:sanction, client: client, service_program_id: 1,sanction_type: 3059,effective_begin_date: "2010-01-20").should_not be_valid

	end

	#17.
	it "is Valid if you create sanction record with different (client ID, Service Program ID, Sanction Type and Effective Begin Date)." do
		client = FactoryGirl.create(:client) 
		FactoryGirl.create(:sanction, client: client, service_program_id: 1,sanction_type: 3059,effective_begin_date: "2010-01-20")
		FactoryGirl.build(:sanction, client: client, service_program_id: 1,sanction_type: 3059,effective_begin_date: "2010-02-20").should be_valid

	end

	
end
