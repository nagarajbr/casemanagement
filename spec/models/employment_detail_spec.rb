require 'rails_helper'

# rspec spec/models/employment_detail_spec.rb -fd
RSpec.describe EmploymentDetail, :type => :model do
  #1.	
    it "has a valid factory" do 
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.create(:employment_detail, employment_id: employer.id).should be_valid
    end

   #2.
   it "is invalid without an effective_begin_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date:nil).should_not be_valid 
	end 

	#3.
	 it "is valid with an effective_begin_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date:"2001-01-30").should be_valid 
	end 

	#4.	hours_per_period
	 it "is invalid without an hours_per_period"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,hours_per_period:nil).should_not be_valid 
	end

	#5. 
	it "is valid with hours_per_period"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,hours_per_period: 160).should be_valid 
	end 

	#6.
	 it "is invalid without a salary_pay_amt"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,salary_pay_amt:nil).should_not be_valid 
	end

	#7. 
	it "is valid with a salary_pay_amt"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,salary_pay_amt:1600.00).should be_valid 
	end 	

	#8.
	 it "is invalid without a salary_pay_frequency"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,salary_pay_frequency:nil).should_not be_valid 
	end

	#9. 
	it "is valid with a salary_pay_frequency"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,salary_pay_frequency: 2317).should be_valid 
	end 	

	#10. current_status
	 it "is invalid without a current_status"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,current_status:nil).should_not be_valid 
	end

	#11. 
	it "is valid with a current_status"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,current_status: 2332).should be_valid 
	end 

	#12.valid effective begin date.
	it "is invalid with an effective_begin_date less than 1900 "  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "0022-01-20").should_not be_valid 
	end 

	#13.valid effective begin date.
	it "is valid with an effective_begin_date greater than 1900 "  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "1995-01-20").should be_valid 
	end 

	# 14. Valid effective end date.
	it "is invalid with an effective_end_date less than 1900 "  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_end_date: "0022-01-20").should_not be_valid 
	end 

	#15.valid effective end date.
	it "is valid with an effective_end_date greater than 1900 "  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_end_date: "1995-01-20").should be_valid 
	end 

	#16.
	it "is invalid with an effective_begin_date greater than  effective_end_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "2014-01-20",effective_end_date: "2013-12-20").should_not be_valid 
	end 

	#16.
	it "is valid with an effective_begin_date less than  effective_end_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id)
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "2013-01-20",effective_end_date: "2014-12-20").should be_valid 
	end

	#17.
	it "is invalid with employment detail effective_begin_date less than  Employment Master effective_begin_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id,effective_begin_date:"2014-01-01")
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "2013-01-20").should_not be_valid 
	end

	#18.
	it "is invalid with employment detail effective_begin_date greater than  Employment Master effective_end_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id,effective_begin_date:"2010-01-01",effective_end_date:"2012-01-01")
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "2013-01-20").should_not be_valid 
	end	

	#19.
	it "is invalid with employment detail effective_end_date less than  Employment Master effective_begin_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id,effective_begin_date:"2014-01-01")
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_end_date: "2013-01-20").should_not be_valid 
	end

	#20.
	it "is invalid with employment detail effective_end_date greater than  Employment Master effective_end_date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id,effective_begin_date:"2010-01-01",effective_end_date:"2012-01-01")
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_end_date: "2013-01-20").should_not be_valid 
	end

	#21. 
	it "is valid with employment detail effective_begin date and effective_end_date with in the range of Employment master begin date and End date"  do
		client =FactoryGirl.create(:client)
		employer = FactoryGirl.create(:employment,client_id:client.id,effective_begin_date:"2010-01-01",effective_end_date:"2014-01-01")
		FactoryGirl.build(:employment_detail, employment_id: employer.id,effective_begin_date: "2012-01-20",effective_end_date: "2013-01-20").should be_valid 
	end





end
