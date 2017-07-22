require 'faker'

FactoryGirl.define do 
	factory :expense_detail do |f| 
		f.expense_due_date  "2014-07-30"
		f.expense_amount "20.00"
		f.created_by 1
		f.updated_by 1
	end

	factory :invalid_expense_detail,parent: :expense_detail do |f| 
		f.expense_due_date  nil
		f.expense_amount nil
		f.created_by 1
		f.updated_by 1
	end
end
