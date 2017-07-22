class AlterTableProgramUnit3 < ActiveRecord::Migration
  def change
  	add_column :program_units, :reeval_date, :date
  end
end
