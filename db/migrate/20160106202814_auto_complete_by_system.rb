class AutoCompleteBySystem < ActiveRecord::Migration
  def change
  	add_column :work_tasks, :auto_complete_by_system, "char(1)"
  end
end
