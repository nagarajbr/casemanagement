class CreateAuditTrailIncomeDetails < ActiveRecord::Migration
  def change
    create_table :audit_trail_income_details, :id => false do |t|
     t.integer :id
     t.references :audit_trail_masters, index: true, null:false
     t.integer :run_id, null: false
      t.integer :month_sequence, null: false
      t.integer :member_sequence, null: false
      t.integer :b_details_sequence, null: false
      t.integer :check_type
      t.date    :date_received
      t.decimal :gross_amt, precision: 8, scale: 2
      t.decimal :adjusted_total, precision: 8, scale: 2
      t.decimal :net_amt, precision: 8, scale: 2
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
    execute "ALTER TABLE audit_trail_income_details ADD PRIMARY KEY (id)"

    execute "CREATE SEQUENCE audit_master_detail_seq"
  end
end
