require 'rails_helper'  
# RSpec.describe ExpenseDetail, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

RSpec.describe ExpenseDetail do
  # Test cases for expenses Id 

  # it "is invalid if expense Id is not available" do
  #   FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_id: nil)).should_not be_valid
  # end
  before :each do
    logged_in_user = FactoryGirl.create(:user,login: "update_user", name: "update_user", email_id: "update_user@email.com")
    AuditModule.set_current_user=(logged_in_user)
  end

  it "is valid if expense Id is available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_id: 1)).should be_valid
  end

  #Test cases for expense due date
  it "is invalid if expense due date is not available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_due_date: nil)).should_not be_valid
  end
  it "is valid if expense due date is available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_due_date: "2014-08-30")).should be_valid
  end
  it "is invalid if expense due date is before expense start date available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_due_date: "2014-06-30")).should_not be_valid
  end
  it "is invalid if expense due date is after expense end date available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_due_date: "2014-09-30")).should_not be_valid
  end


  #Test case for expense amount
  it "is invalid if expense amount is not available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_amount: nil)).should_not be_valid
  end
  it "is valid if expense amount is available" do
    FactoryGirl.create(:expense, :effective_end_date => "2014-08-30").expense_details.build(expense_detail_attributes(expense_amount: "100.00")).should be_valid
  end

end