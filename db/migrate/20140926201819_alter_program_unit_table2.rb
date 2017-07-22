class AlterProgramUnitTable2 < ActiveRecord::Migration
  def change
  		add_column :program_units, :case_type, :integer
  end
end
