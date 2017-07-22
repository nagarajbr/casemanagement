class CreatePaymentLineItems < ActiveRecord::Migration
  def change
    create_table :payment_line_items do |t|
    	t.integer :line_item_type, null: false
    	t.integer :payment_type, null: false
    	t.integer :client_id, null: false
    	t.integer :beneficiary, null: false
    	t.integer :reference_id, null: false
    	t.decimal :payment_amount, precision: 8, scale: 2, null: false
    	t.date :payment_date, null: false
    	t.integer :payment_status, null: false
		t.integer :determination_id, null: false
		t.integer :status
 		t.integer :created_by, null: false
		t.integer :updated_by, null: false
      t.timestamps
    end
  end
end
