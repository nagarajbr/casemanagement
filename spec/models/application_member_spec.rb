require 'rails_helper'

# rspec spec/models/application_member_spec.rb -fd
RSpec.describe ApplicationMember, :type => :model do
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
		client =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		FactoryGirl.create(:application_member, client_application_id: client_application.id,client_id: client.id ).should be_valid
	end

	# 2.
	it "is invalid without a client_application_id" do
		client =FactoryGirl.create(:client)
		FactoryGirl.build(:application_member, client_application_id: nil,client_id: client.id ).should_not be_valid
	end

	# 3. 
	it "is valid with a client_application_id" do
		client =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: client.id ).should be_valid
	end

	# 4. 
	it "is invalid without a client_id" do
		client =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: nil ).should_not be_valid
	end

	# 5. 
	it "is valid with a client_id" do
		client =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: client.id ).should be_valid
	end

	# # 6. 
	it "is invalid without a member_status" do
		client =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: client.id,member_status: nil ).should_not be_valid
	end

	# # 7. 
	it "is valid with a member_status" do
		client =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: client.id,member_status: 4468 ).should be_valid		
	end
	

	# # 8 
	it "is invalid with more than one members selected for Primary Applicant" do
		client1 =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		am1 = FactoryGirl.create(:application_member, client_application_id: client_application.id,client_id: client1.id,primary_member: "Y" )
		client2 =FactoryGirl.create(:client,ssn:"123333111")
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: client2.id,primary_member: "Y"  ).should_not be_valid		
	end

	# # 9. 
	it "is valid with one Primary Applicant" do
		client1 =FactoryGirl.create(:client)
		client_application = FactoryGirl.create(:client_application)
		am1 = FactoryGirl.create(:application_member, client_application_id: client_application.id,client_id: client1.id,primary_member: "N" )
		client2 =FactoryGirl.create(:client,ssn:"123333111")
		FactoryGirl.build(:application_member, client_application_id: client_application.id,client_id: client2.id,primary_member: "Y"  ).should be_valid		

	end


end
