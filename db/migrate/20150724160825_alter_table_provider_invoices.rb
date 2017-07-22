class AlterTableProviderInvoices < ActiveRecord::Migration
  def change
  	rename_column :provider_invoices, :status, :state
  	rename_column :provider_invoices, :status_rejection_reason, :reason
  	remove_column :provider_invoices, :requested_by
  	remove_column :provider_invoices, :requested_date
  	remove_column :provider_invoices, :status_updated_by
  	remove_column :provider_invoices, :status_updated_date
  end
end
