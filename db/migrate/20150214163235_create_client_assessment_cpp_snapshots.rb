class CreateClientAssessmentCppSnapshots < ActiveRecord::Migration
  def change
    create_table :client_assessment_cpp_snapshots do |t|
      t.references :career_pathway_plan, index: true, null:false
      t.integer :client_assessment_id, null:false
      t.integer :client_id, null:false
      t.date :assessment_date, null:false
      t.integer :assessment_status
      t.string :comments
      t.integer :client_assessment_created_by, null:false
      t.integer :client_assessment_updated_by, null:false
      t.timestamp :client_assessment_created_at
      t.timestamp :client_assessment_updated_at
      t.integer :created_by, null:false
      t.integer :updated_by, null:false
      t.timestamps
    end
  end
end
