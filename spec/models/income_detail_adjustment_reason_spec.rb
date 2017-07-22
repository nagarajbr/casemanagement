require 'rails_helper'

# RSpec.describe ExpenseDetail, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

RSpec.describe IncomeDetail do

  before :each do
    @income_detail = FactoryGirl.create(:income).
        income_details.create!(income_detail_attributes)
  end
	it "has a valid factory" do  		
      @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes).should be_valid     
  end

  it "should change the count by one on create with reason only" do
    expect { 
       @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: 138.18, adjusted_reason: nil))
    }.to change(IncomeDetailAdjustReason, :count).by(1)
  end

  it "should change the count by one on create with reason only" do
    expect { 
       @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: nil, adjusted_reason: 4454))
    }.to change(IncomeDetailAdjustReason, :count).by(1)
  end  

  it "deletes associated income details adjust reason on delete of income detail" do
    income = FactoryGirl.create(:income)
    income_detail = income.income_details.create!(income_detail_attributes)
    income_detail.
        income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: 138.18, adjusted_reason: nil))
    income_detail.
        income_detail_adjust_reasons.
           create(income_detail_adjustment_attributes(adjusted_amount: nil, adjusted_reason: 4454))

    expect { 
      income_detail.destroy
    }.to change(IncomeDetailAdjustReason, :count).by(-2)
  end

  it "should be valid with adjusted amount less than equal 6 digits" do
     @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: 123456,)).should be_valid
  end

  it "should be invalid with adjusted amount more than 6 digits" do
     @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: 123456789.1)).should_not be_valid
  end

  it "should be valid with adjusted amount less than equal 2 decimals" do
    @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: 123456.18)).should be_valid
  end

  it "should be invalid with adjusted amount more than 2 decimals" do
     @income_detail.income_detail_adjust_reasons.
            create(income_detail_adjustment_attributes(adjusted_amount: 1234.123)).should_not be_valid
  end

end