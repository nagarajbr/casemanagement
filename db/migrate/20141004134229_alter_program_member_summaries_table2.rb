class AlterProgramMemberSummariesTable2 < ActiveRecord::Migration
  def up
  	remove_column :program_member_summaries, :bu_sum_result
  	remove_column :program_member_summaries, :res_pass_fail_ind
  	remove_column :program_member_summaries, :budget_eligible_ind

  	add_column :program_member_summaries, :unmet_liability, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :supl_sec_income_amount, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :social_security_admin_amt, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :railroad_ret_amt, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :vet_asst_amt, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :other_unearned_inc, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :eligibility_work_deduct, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :eligibility_incent_deduct, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :earned_income_deduct, :decimal, precision: 8, scale: 2
  	add_column :program_member_summaries, :child_care_deduct, :decimal, precision: 8, scale: 2

  	change_column :program_member_summaries, :tot_earned_inc, :decimal, precision: 8, scale: 2
  	change_column :program_member_summaries, :tot_unearned_inc, :decimal, precision: 8, scale: 2
  	change_column :program_member_summaries, :tot_expenses, :decimal, precision: 8, scale: 2
  	change_column :program_member_summaries, :tot_resources, :decimal, precision: 8, scale: 2



  end
end
