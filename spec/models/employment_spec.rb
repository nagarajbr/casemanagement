require 'rails_helper'

# rspec spec/models/employment_spec.rb -fd
RSpec.describe Employment, :type => :model do
  #1.	
    it "has a valid factory" do 
		cl =FactoryGirl.create(:client)
		FactoryGirl.create(:employment, client: cl).should be_valid
    end

    #2.
	it "is invalid without a employer name"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, employer_name: nil).should_not be_valid 
	end

	#3.
	it "is valid with a employer name populated"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, employer_name: "Test").should be_valid 
	end

	# 4.
	it "is invalid without employment begin date"  do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: nil).should_not be_valid 
	end

	#5.
	it "is valid with employment begin date populated" do
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: "2014-12-20").should be_valid 
	end 

	# 6.
	it "is invalid with employment begin date less than 1900" do
		# femaile = 4478
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: "1889-01-01").should_not be_valid 
	end

	#7.
	it "is valid with employment begin date greater than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: "2014-01-01").should be_valid 
	end

	#8.
	it "is valid with null employment end date " do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_end_date: nil).should be_valid 
	end


	#9.
	it "is invalid with employment end date less than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_end_date: "1889-01-01").should_not be_valid 
	end

	#10.
	it "is valid with employment end date greater than 1900" do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_end_date: "2014-01-01").should be_valid 
	end

	#12. 
	it "is invalid with employment begin date greater than employment end date " do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: "2014-01-01",effective_end_date: "2012-01-01").should_not be_valid 
	end

	# 13.
	it "is valid with employment begin date before employment end date " do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: "2012-01-01",effective_end_date: "2014-01-01").should be_valid 
	end

	#14
	it "is valid with employment begin date equal to employment end date " do
		
		client = FactoryGirl.create(:client) 
		FactoryGirl.build(:employment, client: client, effective_begin_date: "2012-01-01",effective_end_date: "2012-01-01").should be_valid 
	end



end
