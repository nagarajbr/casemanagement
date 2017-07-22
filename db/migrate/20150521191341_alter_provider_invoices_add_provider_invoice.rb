class AlterProviderInvoicesAddProviderInvoice < ActiveRecord::Migration
  def change
  	 add_column :provider_invoices, :provider_invoice, "varchar(255)"
  end
end
