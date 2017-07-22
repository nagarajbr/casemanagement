class CreatePrescreenHouseholds < ActiveRecord::Migration
  def change
    create_table :prescreen_households do |t|
      t.string  :household_name,limit: 35
      t.decimal :household_earned_income_amount, precision: 8, scale: 2
      t.decimal :household_unearned_income_amount, precision: 8, scale: 2
      t.decimal :household_expense_amount, precision: 8, scale: 2
      t.decimal :household_resource_amount, precision: 8, scale: 2
      t.decimal :child_care_benefit_amount, precision: 8, scale: 2
	  t.decimal :housing_benefit_amount, precision: 8, scale: 2
	  t.decimal :child_support_benefit_amount, precision: 8, scale: 2
	  t.decimal :student_sholarship_grant_benefit_amount, precision: 8, scale: 2
	  t.decimal :snap_benefit_amount, precision: 8, scale: 2
	  t.decimal :ssi_benefit_amount, precision: 8, scale: 2
	  t.decimal :transportation_benefit_amount, precision: 8, scale: 2
	  t.decimal :veterans_benefit_amount, precision: 8, scale: 2
	  t.decimal :tanf_benefit_amount, precision: 8, scale: 2
	  t.string  :receiving_medicaid_flag, limit: 1
	  t.string  :other_non_govt_beneft_details, limit: 250
	  t.string  :phone, limit: 10
	  t.string  :email_address, limit: 50
	  t.string  :address_line1, limit: 50
	  t.string  :address_line2, limit: 50
	  t.string  :city, limit: 50
	  t.integer :state
	  t.string  :zip, limit: 5
	  t.string :notes, limit: 255
	  t.timestamps
    end
  end
end


