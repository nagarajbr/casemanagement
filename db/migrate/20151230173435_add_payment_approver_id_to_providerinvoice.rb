class AddPaymentApproverIdToProviderinvoice < ActiveRecord::Migration
  def change
  	add_column :provider_invoices, :payment_approver_id, :string
  end
end
