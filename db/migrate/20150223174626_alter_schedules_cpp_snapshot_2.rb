class AlterSchedulesCppSnapshot2 < ActiveRecord::Migration
  def change
  	add_column :schedule_cpp_snapshots, :parent_primary_key_id, :integer
  end
end
