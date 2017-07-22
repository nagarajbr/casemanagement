class CreateTableAssessmentCareers < ActiveRecord::Migration
  def change
    create_table :assessment_careers do |t|
    	t.references :client, index: true
    	t.references :assessment, index: true
    	t.string :career_code, null:false
    	t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
