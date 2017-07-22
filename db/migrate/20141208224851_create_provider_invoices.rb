class CreateProviderInvoices < ActiveRecord::Migration
  def change
    create_table :provider_invoices do |t|
    	 t.references :provider, index: true, null: false
    	 t.date :invoice_date, null: false
    	 t.decimal :invoice_amount, precision: 8, scale: 2
    	 t.string :invoice_notes
    	 t.integer :invoice_status
    	 t.integer :created_by , null:false
      	 t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
