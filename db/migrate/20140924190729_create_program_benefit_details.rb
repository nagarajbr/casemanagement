class CreateProgramBenefitDetails < ActiveRecord::Migration
  def change
    create_table :program_benefit_details do |t|
      	t.integer  :run_id
    	t.integer  :month_sequence
      	t.integer :eligibility_gross_earned
		t.integer :eligibility_work_deduct
		t.integer :eligibility_incent_deduct
		t.integer :eligibility_net_income
		t.integer :eligibility_tot_unearned
		t.integer :eligibility_tot_adjusted
		t.integer :benefit_gross_earned
		t.integer :benefit_work_deduction
		t.integer :benefit_incent_deduct
		t.integer :benefit_net_income
		t.integer :benefit_total_unearned
		t.integer :benefit_total_adjusted
		t.integer :full_benefit
		t.integer :reduction
		t.integer :sanction
		t.integer :program_benefit_amount
		t.integer :social_security_admin_amt
		t.integer :railroad_ret_amt
		t.integer :vet_asst_amt
		t.integer :other_unearned_inc
		t.integer :program_income_limit
	    t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      	t.timestamps
    end
  end
end
