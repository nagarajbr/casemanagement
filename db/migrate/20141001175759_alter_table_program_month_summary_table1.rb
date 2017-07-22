class AlterTableProgramMonthSummaryTable1 < ActiveRecord::Migration
  def change
  	add_column :program_month_summaries, :program_unit_size, :integer
  end
end
