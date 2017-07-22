class CreateAuditTrailIncDetailSecs < ActiveRecord::Migration
  def change
    create_table :audit_trail_inc_detail_secs do |t|
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
  end
end
