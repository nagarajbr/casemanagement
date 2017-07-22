class CreateEventToActionsMappings < ActiveRecord::Migration
  def change
    create_table :event_to_actions_mappings do |t|
    	t.integer :event_type
    	t.integer :action_type
    	t.string :method_name
    	t.integer :sort_order
    	t.integer :task_type
    	t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
