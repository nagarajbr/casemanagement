class AlterClientAssessmentAnswersCppSnapshots2 < ActiveRecord::Migration
  def change
  	add_column :client_assessment_answers_cpp_snapshots,:created_by,:integer,null:false
  	add_column :client_assessment_answers_cpp_snapshots,:updated_by,:integer,null:false

  end
end



