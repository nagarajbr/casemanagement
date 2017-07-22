require 'rails_helper'

describe Client do 
  before :each do
    fake_login()
  end
  def fake_login
    @user = FactoryGirl.create(:user)
        AuditModule.set_current_user=(@user) 
  end
  #1. 
  it "is valid without a Residency" do
  	FactoryGirl.build(:alien, residency: nil).should be_valid 
  end

  #2.
   it "is valid with Residency" do
  		FactoryGirl.build(:alien, residency: "Y").should be_valid 
  	end

  #3.
   it "is invalid without a Client ID" do
  		FactoryGirl.build(:alien, client_id: nil).should_not be_valid 
 	 end

  #4.
 	 it "is Valid with a Client ID" do
  		FactoryGirl.build(:alien, client_id: 1).should be_valid 
 	 end

   # 5.
   it "Client ID is unique" do
   		# CREATE client with SSN
		alien = FactoryGirl.create(:alien, client_id: 1) 
		# try to build client with Sae SSN - it should not be valid.
		FactoryGirl.build(:alien,client_id: 1).should_not be_valid 

   end	 

end





