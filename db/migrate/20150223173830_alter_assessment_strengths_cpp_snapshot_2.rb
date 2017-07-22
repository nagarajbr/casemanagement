class AlterAssessmentStrengthsCppSnapshot2 < ActiveRecord::Migration
  def change
  	add_column :assessment_strengths_cpp_snapshots, :parent_primary_key_id, :integer
  end
end
