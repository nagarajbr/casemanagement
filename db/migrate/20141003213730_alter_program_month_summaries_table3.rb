class AlterProgramMonthSummariesTable3 < ActiveRecord::Migration
  def up
  	change_column :program_month_summaries, :res_pass_fail_ind, :string, limit: 1
  	change_column :program_month_summaries, :budget_eligible_ind, :string, limit: 1

  end
end
