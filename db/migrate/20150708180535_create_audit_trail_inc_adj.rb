class CreateAuditTrailIncAdj < ActiveRecord::Migration
  def change
    create_table :audit_trail_inc_adjs,:id => false do |t|
      t.integer :id
     t.references :audit_trail_masters, index: true, null:false
     t.references :audit_trail_income_details, index: true, null:false
      t.integer :run_id, null: false
      t.integer :month_sequence, null: false
      t.integer :member_sequence, null: false
      t.decimal :adjusted_amount, precision: 8, scale: 2
      t.integer :adjusted_reason
      t.text    :adj_use_ind, limit: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
    execute "ALTER TABLE audit_trail_inc_adjs ADD PRIMARY KEY (id)"

    execute "CREATE SEQUENCE audit_master_inc_adj_seq"
  end
end
