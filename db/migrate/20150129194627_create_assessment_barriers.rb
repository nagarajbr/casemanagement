class CreateAssessmentBarriers < ActiveRecord::Migration
  def change
    create_table :assessment_barriers do |t|
     t.references :client_assessment, index: true
     t.integer :barrier_id, null:false
     t.string :assessment_sub_section_refers
     t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
