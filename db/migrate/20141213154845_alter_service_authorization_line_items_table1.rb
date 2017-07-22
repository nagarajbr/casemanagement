class AlterServiceAuthorizationLineItemsTable1 < ActiveRecord::Migration
  def up
  	add_column :service_authorization_line_items, :line_item_status, :integer
  end
end
