class CreateClientAssessmentHistories < ActiveRecord::Migration
  def change
    create_table :client_assessment_histories do |t|
    	t.integer :parent_primary_key_id,null:false
      t.integer :client_id,null:false
    	t.date :assessment_date,null:false
    	t.integer :assessment_status,null:false
    	t.string :comments
    	t.integer :client_assessment_created_by,null:false
   		t.integer :client_assessment_updated_by,null:false
      t.timestamp :client_assessment_created_at,null:false
      t.timestamp :client_assessment_updated_at,null:false
      t.integer :created_by,null:false
      t.integer :updated_by,null:false
      t.timestamps
    end
  end
end
