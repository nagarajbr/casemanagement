class CreatePrescreenHouseholdQAnswers < ActiveRecord::Migration
  def change
    create_table :prescreen_household_q_answers do |t|
    	t.references :prescreen_household,null: false, index: true
    	t.integer :question_category_id,null: false
    	t.integer :question_id,null: false
    	t.string :answer_flag,limit: 1
      t.timestamps
    end
  end
end
