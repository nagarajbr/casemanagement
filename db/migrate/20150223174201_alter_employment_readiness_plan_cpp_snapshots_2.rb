class AlterEmploymentReadinessPlanCppSnapshots2 < ActiveRecord::Migration
  def change
  	add_column :employment_readiness_plan_cpp_snapshots, :parent_primary_key_id, :integer
  end
end
