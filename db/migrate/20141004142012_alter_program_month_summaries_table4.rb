class AlterProgramMonthSummariesTable4 < ActiveRecord::Migration
  def up
  		change_column :program_month_summaries, :tot_earned_inc, :decimal, precision: 8, scale: 2
  		change_column :program_month_summaries, :tot_unearned_inc, :decimal, precision: 8, scale: 2
  		change_column :program_month_summaries, :tot_expenses, :decimal, precision: 8, scale: 2
  		change_column :program_month_summaries, :tot_resources, :decimal, precision: 8, scale: 2
  		change_column :program_month_summaries, :bu_sum_result, :decimal, precision: 8, scale: 2

  end
end
