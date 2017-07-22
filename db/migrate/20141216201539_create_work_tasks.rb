class CreateWorkTasks < ActiveRecord::Migration
  def change
    create_table :work_tasks do |t|
    	t.integer :assigned_to, null: false
    	t.integer :household_id
    	t.integer :task_category, null: false
    	t.integer :task_type, null: false
    	t.integer :client_id
    	t.integer :beneficiary_type, null: false
    	t.integer :reference_id, null: false
    	t.date :due_date
    	t.date :complete_date
    	t.string :action_text
    	t.string :instructions
    	t.integer :urgency
    	t.string :notes
    	t.integer :status
    	t.integer :created_by, null: false
		t.integer :updated_by, null: false
      t.timestamps
    end
  end
end
