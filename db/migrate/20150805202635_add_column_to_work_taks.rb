class AddColumnToWorkTaks < ActiveRecord::Migration
  def change
  	add_column :work_tasks, :program_unit_id, :integer
  end
end
