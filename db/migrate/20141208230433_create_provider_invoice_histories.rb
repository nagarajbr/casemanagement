class CreateProviderInvoiceHistories < ActiveRecord::Migration
  def change
    create_table :provider_invoice_histories do |t|
    	 t.references :provider, index: true, null: false
    	 t.date :invoice_date, null: false
    	 t.decimal :invoice_amount, precision: 8, scale: 2
    	 t.string :invoice_notes
    	 t.integer :invoice_status
    	 t.integer :invoice_created_by , null:false
      	 t.integer :invoice_updated_by , null:false
      	 t.timestamp :invoice_created_at , null:false
      	 t.timestamp :invoice_updated_at , null:false
      	 t.integer :created_by , null:false
      t.timestamps
    end
  end
end
