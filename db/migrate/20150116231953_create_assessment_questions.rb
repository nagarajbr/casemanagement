class CreateAssessmentQuestions < ActiveRecord::Migration
  def change
    create_table :assessment_questions do |t|
    	t.references :assessment_sub_section, index: true, null: false
    	  t.string :title, null:false
    	  t.text :question_text, null:false
    	  t.integer :display_order, null:false
    	  t.integer :enbled, null:false
    	  t.integer :required, null:false
    	  t.integer :input_type_id, null:false
       t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
