class CreateProgramMonthSummaries < ActiveRecord::Migration
  def change
    create_table :program_month_summaries do |t|
       t.integer  :run_id
      t.integer  :month_sequence
       	t.integer :tot_earned_inc
		t.integer :tot_unearned_inc
		t.integer :tot_expenses
		t.integer :tot_resources
		t.integer :bu_sum_result
		t.integer :res_pass_fail_ind
		t.text :budget_eligible_ind, limit:1
       	t.integer :created_by , null:false
       	t.integer :updated_by , null:false
       	t.timestamps
    end
  end
end
