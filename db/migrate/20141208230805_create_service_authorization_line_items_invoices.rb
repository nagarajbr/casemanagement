class CreateServiceAuthorizationLineItemsInvoices < ActiveRecord::Migration
  def change
    create_table :service_authorization_line_items_invoices do |t|
    	  t.integer :provider_invoice_id, null: false
    	  t.integer :service_authorization_line_item_id, null: false
    	  t.integer :created_by , null:false
      	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
