class AlterWorkTaskInstructionsField < ActiveRecord::Migration
  def change
  	change_column :work_tasks, :instructions, "text"
  end

end
