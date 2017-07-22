class AlterTableProviderInvoice2 < ActiveRecord::Migration
  def change
  	 remove_column :provider_invoices, :aasis_warrant
  	 remove_column :provider_invoices, :aasis_paid_date
  end
end
