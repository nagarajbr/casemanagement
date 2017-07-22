class AlterProgramMonthSummariesTable2 < ActiveRecord::Migration
  def up
  	add_column :program_month_summaries, :program_wizard_id, :integer
  end
end
