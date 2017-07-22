class CreateBarriers < ActiveRecord::Migration
  def change
    create_table :barriers do |t|
      t.integer :assessment_section_id, null:false
      t.string :description, null:false
      t.integer :confirmed, null:false
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
