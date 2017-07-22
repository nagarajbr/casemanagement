class AlterServiceAuthorizationLineItemsActualQty < ActiveRecord::Migration
  def change
  	change_column :service_authorization_line_items, :actual_quantity, :decimal,precision: 8, scale: 2
  end
end
