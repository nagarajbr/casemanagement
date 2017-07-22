class ChangeAuditIncomeSharedTableColumn < ActiveRecord::Migration
  def change
  	rename_column :audit_trail_shareds, :clients_id, :client_id
  	rename_column :audit_trail_shared_secs, :clients_id, :client_id
  end
end
