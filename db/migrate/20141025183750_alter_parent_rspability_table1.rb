class AlterParentRspabilityTable1 < ActiveRecord::Migration
  def up
  	add_column :client_parental_rspabilities, :parent_status, :integer,null: false
  end
end
