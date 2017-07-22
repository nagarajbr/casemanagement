class AlterProgramUnits4 < ActiveRecord::Migration
  def change
  	 add_column :program_units, :case_manager_id, :integer
  end
end
