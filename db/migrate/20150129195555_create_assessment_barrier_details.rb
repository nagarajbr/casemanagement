class CreateAssessmentBarrierDetails < ActiveRecord::Migration
  def change
    create_table :assessment_barrier_details do |t|
      t.references :assessment_barrier, index: true
      t.references :assessment_sub_section, index: true
      t.text :comments
      t.integer :display_order, null:false
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
