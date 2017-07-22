class CreateAssessmentQuestionMetadata < ActiveRecord::Migration
  def change
    create_table :assessment_question_metadata do |t|
    	t.references :assessment_question, index: true, null: false
    	t.string :response_data_type
	    t.integer :response__min_lngth
		t.integer :response__max_lngth
	    t.string :response_frmt_msk
		t.string :response_min_val
		t.string :response_max_val
		t.string :response_var_nm
		t.string :response_err_msg
		t.string :style_info
		t.string :style_class
		t.string :prompt_style_info
		t.string :prompt_style_class
       t.integer :created_by , null:false
   		 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
