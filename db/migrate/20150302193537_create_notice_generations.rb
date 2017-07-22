class CreateNoticeGenerations < ActiveRecord::Migration
  def change
    create_table :notice_generations do |t|
     	t.date :notice_generated_date, null:false
    	t.integer :action_type, null:false
    	t.integer :action_reason, null:false
    	t.date :date_to_print,null:false
    	t.integer :notice_status
    	t.integer :created_by, null:false
      t.integer :updated_by, null:false
      t.timestamps
    end
  end
end
