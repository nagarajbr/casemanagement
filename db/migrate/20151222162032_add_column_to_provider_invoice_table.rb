class AddColumnToProviderInvoiceTable < ActiveRecord::Migration
  def change
  	add_column :provider_invoices, :service_authorization_id, :integer
  end
end
