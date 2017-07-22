class CreateAssessmentStrengths < ActiveRecord::Migration
  def change
    create_table :assessment_strengths do |t|
      t.references :client_assessment, index: true
      t.references :assessment_sub_section, index: true
      t.text :comments
      t.integer :display_order, null:false
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
