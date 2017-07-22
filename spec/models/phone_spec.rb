require 'rails_helper'

# rspec spec/models/phone_spec.rb
describe Phone do 
	#1.
	it "does not allow duplicate phone types per client" do 
		client = FactoryGirl.create(:client) 
		FactoryGirl.create(:phone, client: client, phone_type: 4661, number: 5015884057)
		FactoryGirl.build(:phone, client: client, phone_type: 4661,number: 5011234567).should_not be_valid 
		
	end		


	

	#3.
	it "Phone number is invalid with non numeric data" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, phone_type: 4661,number: "abcdefghij").should_not be_valid 
	end

	#4.
	it "Phone number is valid with numeric data" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, number: "1234567891").should be_valid
	end

	#5.
	it "is valid with Client ID" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client_id: client.id).should be_valid 
	end

	# #6.
	it "is Invalid without Client ID" do
		FactoryGirl.build(:phone, client: nil).should_not be_valid 
	end

	# #7.
	it "is valid with 10 digit phone number" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, number: "1234567891").should be_valid
	end

	# #8.
	it "is Invalid with phone numbers less than 10 digits" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, number: "123456789").should_not be_valid
	end

	# #9.
	it "is Invalid with phone numbers more than 10 digits" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, number: "1234567891234").should_not be_valid
	end

	# #10.
	it "is invalid without phone number" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, number: nil).should_not be_valid
	end

	# #11.
	it "is valid with phone number"	 do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:phone, client: client, number: "1234567891").should be_valid
	end


	
end 

