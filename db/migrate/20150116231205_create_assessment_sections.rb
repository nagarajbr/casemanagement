class CreateAssessmentSections < ActiveRecord::Migration
  def change
    create_table :assessment_sections do |t|
      t.string :title, null:false
      t.string :description, null:false
      t.integer :display_order, null:false
       t.integer :enabled, null:false
      t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
