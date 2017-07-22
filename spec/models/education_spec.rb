require 'rails_helper'

# RSpec.describe Education, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

RSpec.describe Education,:type => :model  do

  before :each do
    @client = FactoryGirl.create(:client)
  end
  #Test case to check if we can create education details for a client with minimum details 
 	it "has a valid factory" do
		FactoryGirl.create(:education,client_id: @client.id).should be_valid
	end

	#Test case to check school type fields
	it "is invalid without a school type"  do
		FactoryGirl.build(:education, client_id: @client.id, school_type: nil).should_not be_valid
	end

	it "is valid with a school type"  do
		FactoryGirl.build(:education, client_id: @client.id, school_type: "High School").should be_valid
	end


	#Test case to check highest grade level fields
	it "is invalid without a high grade level"  do
		FactoryGirl.build(:education, client_id: @client.id, high_grade_level: nil).should_not be_valid
	end

	it "is valid with a high grade level"  do
		FactoryGirl.build(:education, client_id: @client.id, high_grade_level: "08").should be_valid
	end

  #Test case to check effective begin date is less than effective end date
  it "is invalid to have effective begin date greater than effective end date" do
    education=FactoryGirl.build(:education, client_id: @client.id, effective_beg_date: "01-01-2010", effective_end_date: "01-01-2009")
    education.begin_date_cannot_be_less_than_end_date.should == false
  end

  it "is valid to have effective begin date less than effective end date" do
    education=FactoryGirl.build(:education, client_id: @client.id, effective_beg_date: "01-01-2010", effective_end_date: "01-01-2011")
    education.begin_date_cannot_be_less_than_end_date.should == true
  end


  #Test case to check effective begin date greater than  01-01-1900
  it "is invalid to have effective begin date before 1900" do
  	education=FactoryGirl.build(:education, client_id: @client.id, effective_beg_date: "01-01-1899")
  	education.valid_begin_date?.should == false
  end

  it "is valid to have effective begin date after 1900" do
  	education=FactoryGirl.build(:education, client_id: @client, effective_beg_date: "01-02-1900")
  	education.valid_begin_date?.should == true
  end

  #Test cases to check effective end date greater than  01-01-1900
  it "is invalid to have effective end date before 1900" do
  	education=FactoryGirl.build(:education, client_id: @client.id, effective_end_date: "01-01-1899")
  	education.valid_end_date?.should == false
  end

  it "is valid to have effective end date after 1900" do
  	education=FactoryGirl.build(:education, client_id: @client.id, effective_end_date: "01-02-1900")
  	education.valid_end_date?.should == true
  end


  #Test cases to check eexpected grad date greater than  01-01-1900
  it "is invalid to have expected graduation date before 1900" do
  	education=FactoryGirl.build(:education, client_id: @client.id, expected_grad_date: "01-01-1899")
  	education.valid_graduation_date?.should == false
  end

  it "is valid to have expected graduation date after 1900" do
  	education=FactoryGirl.build(:education, client_id: @client.id, expected_grad_date: "01-02-1900")
  	education.valid_graduation_date?.should == true
  end

end
