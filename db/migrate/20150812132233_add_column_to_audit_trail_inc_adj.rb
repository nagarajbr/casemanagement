class AddColumnToAuditTrailIncAdj < ActiveRecord::Migration
  def change
  	add_column :audit_trail_inc_adjs, :b_details_sequence, :integer
  end
end
