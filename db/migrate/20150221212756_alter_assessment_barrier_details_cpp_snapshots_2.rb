class AlterAssessmentBarrierDetailsCppSnapshots2 < ActiveRecord::Migration
  def change
  		add_column :assessment_barrier_details_cpp_snapshots, :parent_primary_key_id, :integer
  end
end
