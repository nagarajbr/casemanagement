class AlterWorkTasks2 < ActiveRecord::Migration
  def change
  	 add_column :work_tasks, :assigned_by_user_id, :integer
  	 add_column :work_tasks, :assigned_to_type, :integer
  	 rename_column :work_tasks, :assigned_to, :assigned_to_id
  	 change_column :work_tasks, :beneficiary_type, :integer, null:true
  	 change_column :work_tasks, :reference_id, :integer, null:true

  end
end
