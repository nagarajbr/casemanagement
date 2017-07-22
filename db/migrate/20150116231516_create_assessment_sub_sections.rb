class CreateAssessmentSubSections < ActiveRecord::Migration
  def change
    create_table :assessment_sub_sections do |t|
    	t.references :assessment_section, index: true, null: false
    	  t.string :title, null:false
      t.string :description, null:false
      t.integer :display_order, null:false
       t.integer :enabled, null:false
        t.integer :all_sub_section_order
        t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
