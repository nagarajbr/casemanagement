class ChangeAuditMasterTableColumn < ActiveRecord::Migration
 def change
  	rename_column :audit_trail_masters, :type, :inc_exp_type
  end
end
