class CreateClientAssessments < ActiveRecord::Migration
  def change
    create_table :client_assessments do |t|
    	t.integer :client_id,  null:false
    	t.date :assessment_date, null:false
    	t.integer :assessment_status, null:false
    	t.string :comments
    	t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
