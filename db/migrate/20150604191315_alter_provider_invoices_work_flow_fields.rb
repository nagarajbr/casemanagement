class AlterProviderInvoicesWorkFlowFields < ActiveRecord::Migration
  def change
  		add_column :provider_invoices, :requested_by, :integer
	  	add_column :provider_invoices, :requested_date, :datetime

  		add_column :provider_invoices, :status, :integer
  		add_column :provider_invoices, :status_updated_by, :integer
  		add_column :provider_invoices, :status_updated_date, :datetime

  		add_column :provider_invoices, :status_rejection_reason, :string
  end
end
