class CreateEntityQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :entity_question_answers do |t|
    	t.integer :entity_id, null: false
    	t.integer :entity_type, null: false
    	t.integer :question_category_id, null: false
    	t.integer :question_id, null: false
      	t.string :answer_flag, limit: 1
      	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
      	t.timestamps
    end
  end
end
