require 'rails_helper'

# rspec spec/models/client_relationship_spec.rb -fd
RSpec.describe ClientRelationship, :type => :model do
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
  # Relationship - child -6009
  # Relationship - Parent - 5977
  # 

   #1.
	it "has a valid factory" do 
		from_client =FactoryGirl.create(:client)
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		FactoryGirl.create(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:6009 ).should be_valid
	end

	#2. 
	it "is invalid without From client id" do
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		FactoryGirl.build(:client_relationship, from_client_id: nil,to_client_id: to_client.id,relationship_type:6009 ).should_not be_valid
	end

	#3. 
	it "is valid with From client id" do
		from_client =FactoryGirl.create(:client)
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		FactoryGirl.build(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:6009 ).should be_valid		
	end

	#4. 
	it "is invalid without To client id" do
		from_client =FactoryGirl.create(:client)
		FactoryGirl.build(:client_relationship, from_client_id: from_client.id,to_client_id: nil,relationship_type:6009 ).should_not be_valid		
	end

	#5. 
	it "is valid with To client id" do
		from_client =FactoryGirl.create(:client)
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		FactoryGirl.build(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:6009 ).should be_valid		
	end

	# 6. 
	it "is invalid without relationship_type" do
		from_client =FactoryGirl.create(:client)
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		FactoryGirl.build(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:nil ).should_not be_valid		
	end

	# 7. 
	it "is valid with relationship_type" do
		from_client =FactoryGirl.create(:client)
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		FactoryGirl.build(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:6009 ).should be_valid		

	end

	# 8. 
	it "invalid with duplicate From client ID , relationship type and To client ID." do
		from_client =FactoryGirl.create(:client)
		to_client =FactoryGirl.create(:client,ssn:"123111222")
		cr1 = FactoryGirl.create(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:6009 )
		FactoryGirl.build(:client_relationship, from_client_id: from_client.id,to_client_id: to_client.id,relationship_type:6009 ).should_not be_valid

	end



end
