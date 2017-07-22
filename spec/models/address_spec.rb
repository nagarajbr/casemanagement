require 'rails_helper'


describe Client,:type => :model do 
	before :each do
		fake_login()
	end
	def fake_login
		@user = FactoryGirl.create(:user)
        AuditModule.set_current_user=(@user) 
	end
	#1.
	it "has a valid factory" do 
		FactoryGirl.create(:address).should be_valid
	end

	#1. address_type
	it "is Invalid without address_type" do
		FactoryGirl.build(:address, address_type: nil).should_not be_valid 
	end

	#2.
	it "is Valid with address_type"	do
		FactoryGirl.build(:address, address_type: 4664).should be_valid 
	end 

	#3.:address_line1
	it "is Invalid without address_line1" do
		FactoryGirl.build(:address, address_line1: nil).should_not be_valid 
	end

	#4.
	it "is Valid without address_line1" do
		FactoryGirl.build(:address, address_line1: "1 Capitol Ave").should be_valid 
	end

	#5.city
	it "is Invalid without City"  do
		FactoryGirl.build(:address, city: nil).should_not be_valid 
	end

	#6. 
	it "is Valid with  City" do
		FactoryGirl.build(:address, city: "Little").should be_valid 
	end

	#7.state
	it "is Invalid without State" do 
		FactoryGirl.build(:address, state: nil).should_not be_valid 
	end

	#8.
	it "is Valid with State" do
		# state -4667 = AR
			FactoryGirl.build(:address, state: 4667).should be_valid
	end	 

	#9.zip
	it "is Invalid with No Zip" do
		FactoryGirl.build(:address, zip: nil).should_not be_valid 
	end

	#10
	it "is Valid with Zip" do
		FactoryGirl.build(:address, zip: "72223").should be_valid 
	end

	# 11.
	# it "Only one Mailing address per client" do

	# end

	# 12.
	# it "Only one Residential address per client" do
	# end

end	

