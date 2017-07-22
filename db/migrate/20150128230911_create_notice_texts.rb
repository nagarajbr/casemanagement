class CreateNoticeTexts < ActiveRecord::Migration
  def change
    create_table :notice_texts do |t|
      t.references :service_program, index: true, null: false
      t.integer :action_type
      t.integer :action_reason
      t.boolean :flag1
      t.boolean :flag2
      t.text    :notice_text
      t.integer :created_by , null:false
   	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
