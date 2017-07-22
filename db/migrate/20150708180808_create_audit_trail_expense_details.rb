class CreateAuditTrailExpenseDetails < ActiveRecord::Migration
  def change
    create_table :audit_trail_expense_details, :id => false do |t|
      t.integer :id
      t.references :audit_trail_masters, index: true, null:false
      t.integer :run_id, null: false
      t.integer :month_sequence, null: false
      t.integer :member_sequence, null: false
      t.integer :b_details_sequence, null: false
      t.date :expense_due_date
      t.decimal :expense_amount, precision: 8, scale: 2
      t.integer :expense_use_code
      t.integer :payment_status
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
     execute "ALTER TABLE audit_trail_expense_details ADD PRIMARY KEY (id)"

     execute "CREATE SEQUENCE audit_master_expense_detail_seq"
  end
end
