class ModifyPaymentReviewerId < ActiveRecord::Migration
  def change
  	add_column :provider_invoices, :payment_reviewer_id, :string
  end
end
