require 'rails_helper'


# RSpec.describe Client, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end



describe Pregnancy,:type => :model do 
	
	#1.
	it "has a valid factory" do 
		cl =FactoryGirl.create(:client,gender:4478)
		FactoryGirl.create(:pregnancy, client: cl).should be_valid
	end


	#2.
	it "is invalid without a pregnancy_due_date"  do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, pregnancy_due_date: nil).should_not be_valid 
	end

	#3.
	it "is valid with a pregnancy_due_date"  do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, pregnancy_due_date: "2014-01-01").should be_valid 
	end

	# 4.
	it "is invalid without a number of unborn children"  do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, number_of_unborn: nil).should_not be_valid 
	end

	#5.
	it "is valid with number of unborn children populated" do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, number_of_unborn: 2).should be_valid 
	end 

	#6.
	it "is valid with number of unborn children is greater than zero" do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, number_of_unborn: 2).should be_valid 
	end 

	#7.
	it "is invalid with number of unborn children equal to zero" do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, number_of_unborn: 0).should_not be_valid 
	end

	#8.
	it "is invalid number of unborn children less than zero" do
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, number_of_unborn: -1).should_not be_valid 
	end

	#9.
	it "is invalid if client's gender is not female" do
		# gender = Male
		client = FactoryGirl.create(:client,gender:4479) 
		FactoryGirl.build(:pregnancy, client: client).should_not be_valid 
	end

	# 10.
	it "is valid if client's gender is female" do
		# femaile = 4478
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client).should be_valid 
		
	end

	# 10.
	it "is invalid with pregnancy_due_date less than 1900" do
		# femaile = 4478
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, pregnancy_due_date: "1889-01-01").should_not be_valid 
	end

	#11.
	it "is valid with pregnancy_due_date greater than 1900" do
		# femaile = 4478
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, pregnancy_due_date: "2014-01-01").should be_valid 
	end

	# 12.
	it "is invalid with pregnancy_termination_date less than 1900" do
		# femaile = 4478
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, pregnancy_termination_date: "1889-01-01").should_not be_valid 
	end

	# 13.
	it "is valid with pregnancy_termination_date greater than 1900" do
		# femaile = 4478
		client = FactoryGirl.create(:client,gender:4478) 
		FactoryGirl.build(:pregnancy, client: client, pregnancy_termination_date: "2014-01-01").should be_valid 
	end

	
end 
