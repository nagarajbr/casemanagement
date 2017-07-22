require 'rails_helper'



# rspec spec/models/client_spec.rb -fd

describe Client do 
	#1.
	it "has a valid factory" do 
		FactoryGirl.create(:client).should be_valid
	end

	#2.
	it "is invalid without a firstname"  do
		FactoryGirl.build(:client, first_name: nil).should_not be_valid 
		
	end

	#3.
	it "is valid with a firstname populated"  do
		FactoryGirl.build(:client, first_name: "John").should be_valid 
		
	end

	#4.
	# it "firstname does not accepts Non alphabets" do
	# 	FactoryGirl.build(:client, first_name: "123ABCD").should_not be_valid 
	# end

	#5.
	# it "firstname accepts only alphabets" do
	# 	FactoryGirl.build(:client, first_name: "John").should be_valid 
	# end
	

	#6.
	it "is invalid without a lastname" do
		FactoryGirl.build(:client, last_name: nil).should_not be_valid 

	end 

	#7.
	it "is valid with a lastname populated" do
		FactoryGirl.build(:client, last_name: "DOE").should be_valid 

	end 

	#8.
	it "does not allow duplicate SSN per client" do 
		# CREATE client with SSN
		client = FactoryGirl.create(:client, ssn: "123456789") 
		# try to build client with Sae SSN - it should not be valid.
		FactoryGirl.build(:client,ssn: "123456789").should_not be_valid 

	end 

	#9.
	it "Only numbers are allowed for SSN" do 
		# build client with date less than 1900
		FactoryGirl.build(:client, ssn: "ABCD1234").should_not be_valid 
	end


	#10.
	it "Date of Birth is invalid if year is befiore 1900 " do
		# build client with date less than 1900
		FactoryGirl.build(:client, dob: "1898-12-31").should_not be_valid 
	end

	#11.
	it "Date of Birth is valid if it is between 1900 and now" do
		# build client with date less than 1900
		FactoryGirl.build(:client, dob: "2010-12-31").should be_valid 
	end


	#12.
	it "Date of Death is invalid if year is before 1900 " do
		# build client with date less than 1900
		FactoryGirl.build(:client, death_date: "1898-12-31").should_not be_valid 
	end

	#13.
	it "Date of Death is Valid if date is between 1900 and now" do
		# build client with date less than 1900
		FactoryGirl.build(:client, death_date: "2010-12-31").should be_valid 
	end

	#14.
	it "Death date must be greater than birth date" do
		FactoryGirl.build(:client, dob: "2010-12-20",death_date: "2009-12-20").should_not be_valid 

	end
	
end 
