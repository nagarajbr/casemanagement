class AlterTableProviderInvoice1 < ActiveRecord::Migration
  def up
  	add_column :provider_invoices, :aasis_warrant, :string
  	add_column :provider_invoices, :aasis_paid_date, :date
  end
end
