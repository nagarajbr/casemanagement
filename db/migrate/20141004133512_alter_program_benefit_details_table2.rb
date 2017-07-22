class AlterProgramBenefitDetailsTable2 < ActiveRecord::Migration
  def up
  	add_column :program_benefit_details, :sanction_indicator, :string, limit: 1
  	change_column :program_benefit_details, :eligibility_gross_earned, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :eligibility_work_deduct, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :eligibility_incent_deduct, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :eligibility_net_income, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :eligibility_tot_unearned, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :eligibility_tot_adjusted, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :benefit_gross_earned, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :benefit_work_deduction, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :benefit_incent_deduct, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :benefit_net_income, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :benefit_total_unearned, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :benefit_total_adjusted, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :full_benefit, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :reduction, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :sanction, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :program_benefit_amount, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :social_security_admin_amt, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :railroad_ret_amt, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :vet_asst_amt, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :other_unearned_inc, :decimal, precision: 8, scale: 2
  	change_column :program_benefit_details, :program_income_limit, :decimal, precision: 8, scale: 2

  end
end
