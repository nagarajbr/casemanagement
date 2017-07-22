class AlterTableServiceAuthorizationLineItems3 < ActiveRecord::Migration
  def change
  	add_column :service_authorization_line_items, :provider_invoice_id, :integer
  end
end
