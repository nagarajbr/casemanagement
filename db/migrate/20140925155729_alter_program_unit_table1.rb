class AlterProgramUnitTable1 < ActiveRecord::Migration
  def change
  	add_column :program_units, :program_unit_status, :integer
  end
end
